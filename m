Return-Path: <linux-kernel-owner+w=401wt.eu-S1756715Ab0ANNss@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756715Ab0ANNss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jan 2010 08:48:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756090Ab0ANNss
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jan 2010 08:48:48 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:34297 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756662Ab0ANNsr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jan 2010 08:48:47 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4B4F20B3.703@s5r6.in-berlin.de>
Date: Thu, 14 Jan 2010 14:48:35 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.23) Gecko/20100102 SeaMonkey/1.1.18
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/24] MAINTAINERS: Document new "Q:" patchwork queue
 type
References: <cover.1263452908.git.joe@perches.com> <dad0b9fe4d42d6523c16edfc5275a01de1272fd4.1263452908.git.joe@perches.com>
In-Reply-To: <dad0b9fe4d42d6523c16edfc5275a01de1272fd4.1263452908.git.joe@perches.com>
X-Enigmail-Version: 0.96.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joe Perches wrote:

You forgot to document here why this is needed or desirable.

> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  MAINTAINERS |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index b8852f8..8dd1fd0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -71,6 +71,7 @@ Descriptions of section entries:
>  	M: Mail patches to: FullName <address@domain>
>  	L: Mailing list that is relevant to this area
>  	W: Web-page with status/info
> +	Q: Patchwork web based patch tracking system site
>  	T: SCM tree type and location.  Type is one of: git, hg, quilt, stgit.
>  	S: Status, one of the following:
>  	   Supported:	Someone is actually paid to look after this.

The proposed entry type is somewhat redundant:
  - L: contains the development list of a subsystem.  Patchwork is fed
    from those lists.  Patchwork users look at the few known patchwork
    sites (the original one at ozlabs.org, the newer one at kernel.org)
    and see all the lists that are hosted there.
  - Projects with a web site, listed in their W: entry, almost certainly
    document there where their patchwork site is, if they use one.
-- 
Stefan Richter
-=====-==-=- ---= -===-
http://arcgraph.de/sr/
