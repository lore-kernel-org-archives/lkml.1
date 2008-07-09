Return-Path: <linux-kernel-owner+w=401wt.eu-S1756306AbYGIBKi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756306AbYGIBKi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2008 21:10:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751550AbYGIBK3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jul 2008 21:10:29 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:46087 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751482AbYGIBK3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2008 21:10:29 -0400
Subject: Re: [PATCH] init/version.c: Silenced sparse warning by declaring
	the version string.
From: Josh Triplett <josht@linux.vnet.ibm.com>
To: Daniel Guilak <guilak@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, trivial@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       daniel@danielguilak.com
In-Reply-To: <1215552069.10304.6.camel@dguilak-desk>
References: <1215552069.10304.6.camel@dguilak-desk>
Content-Type: text/plain
Date: Tue, 08 Jul 2008 18:10:28 -0700
Message-Id: <1215565828.3071.42.camel@josh-work.beaverton.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-07-08 at 14:21 -0700, Daniel Guilak wrote:
> Signed-off-by: Daniel Guilak <daniel@danielguilak.com>

Looks reasonable.

Acked-by: Josh Triplett <josh@kernel.org>

> ---
>  init/version.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/init/version.c b/init/version.c
> index 9d17d70..041fd82 100644
> --- a/init/version.c
> +++ b/init/version.c
> @@ -16,6 +16,7 @@
>  #define version(a) Version_ ## a
>  #define version_string(a) version(a)
> 
> +extern int version_string(LINUX_VERSION_CODE);
>  int version_string(LINUX_VERSION_CODE);
> 
>  struct uts_namespace init_uts_ns = {

