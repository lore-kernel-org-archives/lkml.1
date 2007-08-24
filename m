Return-Path: <linux-kernel-owner+w=401wt.eu-S1763142AbXHXVlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763142AbXHXVlz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758786AbXHXVlr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:41:47 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:53432 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758758AbXHXVlq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:41:46 -0400
Subject: Re: [2.6 patch] fix export_report.pl
From: Ram Pai <linuxram@us.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20070824210451.GE30705@stusta.de>
References: <20070824210451.GE30705@stusta.de>
Content-Type: text/plain
Date: Fri, 24 Aug 2007 14:40:42 -0700
Message-Id: <1187991642.2910.15.camel@ram.us.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2007-08-24 at 23:04 +0200, Adrian Bunk wrote:
> This patch fixes an annoying bug of export_report.pl missing the usages 
> of some exports.
> 
> Signed-off-by: Adrian Bunk <bunk@kernel.org>
> 
> ---
> 
> This patch has been sent on:
> - 14 Aug 2007
> 
> --- a/scripts/export_report.pl
> +++ b/scripts/export_report.pl
> @@ -112,7 +112,7 @@ foreach my $thismod (@allcfiles) {
>  			next;
>  		}
>  		if ($state eq 2) {
> -			if ( $_ !~ /0x[0-9a-f]{7,8},/ ) {
> +			if ( $_ !~ /0x[0-9a-f]+,/ ) {
>  				next;
>  			}
>  			my $sym = (split /([,"])/,)[4];

Adrian,
      I am fine with these changes.

RP

