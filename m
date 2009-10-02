Return-Path: <linux-kernel-owner+w=401wt.eu-S1757392AbZJBJZI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757392AbZJBJZI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 05:25:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755318AbZJBJZH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 05:25:07 -0400
Received: from 1wt.eu ([62.212.114.60]:49778 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755217AbZJBJZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 05:25:05 -0400
Date: Fri, 2 Oct 2009 11:25:07 +0200
From: Willy Tarreau <w@1wt.eu>
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Subject: [PATCH 2.4] Fix Kernel 2.4 build with bash 4
Message-ID: <20091002092507.GA26741@1wt.eu>
References: <20091002111711.5de3bf8f@strolchi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091002111711.5de3bf8f@strolchi>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stefan,

On Fri, Oct 02, 2009 at 11:17:11AM +0200, Stefan Seyfried wrote:
> 
> Signed-off-by: Stefan <stefan.seyfried@googlemail.com>
> ---
>  scripts/Configure |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/scripts/Configure b/scripts/Configure
> index 1a3af43..7a73423 100644
> --- a/scripts/Configure
> +++ b/scripts/Configure
> @@ -546,9 +546,9 @@ if [ -f $DEFAULTS ]; then
>    echo "#"
>    echo "# Using defaults found in" $DEFAULTS
>    echo "#"
> -  . $DEFAULTS
> +  . ./$DEFAULTS
>    sed -e 's/# \(CONFIG_[^ ]*\) is not.*/\1=n/' <$DEFAULTS >.config-is-not.$$
> -  . .config-is-not.$$
> +  . ./.config-is-not.$$
>    rm .config-is-not.$$
>  else
>    echo "#"

This is amazing it has ever worked at all ! None of my scripts which use
". $file" without "./" work even in bash 3. Probably this depends on some
PATH variables and maybe your environment has changed since you upgarded
to bash 4. 

Thanks for the fix, I'll merge it.
Willy

