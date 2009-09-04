Return-Path: <linux-kernel-owner+w=401wt.eu-S933837AbZIDSzl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933837AbZIDSzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 14:55:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933824AbZIDSzk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 14:55:40 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:52591 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933788AbZIDSzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 14:55:39 -0400
From: Frans Pop <elendil@planet.nl>
To: Ben Hutchings <ben@decadent.org.uk>
Subject: Re: [PATCH] builddeb: Fix packaged file permissions
Date: Fri, 4 Sep 2009 20:55:39 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, maximilian attems <max@stro.at>,
       linux-kbuild@vger.kernel.org
References: <1252015231.3475.9.camel@localhost>
In-Reply-To: <1252015231.3475.9.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909042055.40187.elendil@planet.nl>
X-OriginalArrivalTime: 04 Sep 2009 18:55:41.0016 (UTC) FILETIME=[4C7BA580:01CA2D91]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added linux-kbuild to CC.

On Friday 04 September 2009, Ben Hutchings wrote:
> The packaged files' permissions are implicitly dependent on the
> current umask.  Not only can this result in surprisingly restrictive
> permissions, but dpkg-deb will fail if the DEBIAN directory does not
> have permissions 755 or 775.  Therefore, set the umask to 022 before
> building a package.
>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Acked-by: Frans Pop <elendil@planet.nl>

> ---
>  scripts/package/builddeb |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/scripts/package/builddeb b/scripts/package/builddeb
> index 8b357b0..24cfd80 100644
> --- a/scripts/package/builddeb
> +++ b/scripts/package/builddeb
> @@ -12,6 +12,8 @@
>
>  set -e
>
> +umask 022
> +
>  create_package() {
>  	local pname="$1" pdir="$2"
> 
