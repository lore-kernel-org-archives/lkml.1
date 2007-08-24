Return-Path: <linux-kernel-owner+w=401wt.eu-S1765368AbXHXVtQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765368AbXHXVtQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 17:49:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760992AbXHXVtB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 17:49:01 -0400
Received: from mailout.stusta.mhn.de ([141.84.69.5]:57353 "EHLO
	mailhub.stusta.mhn.de" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760764AbXHXVtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 17:49:00 -0400
Date: Fri, 24 Aug 2007 23:47:43 +0200
From: Adrian Bunk <bunk@kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Ram Pai <linuxram@us.ibm.com>,
       Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [2.6 patch] fix export_report.pl
Message-ID: <20070824214743.GH30705@stusta.de>
References: <20070824210451.GE30705@stusta.de> <Pine.LNX.4.64.0708242331490.28540@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0708242331490.28540@fbirervta.pbzchgretzou.qr>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 24, 2007 at 11:36:40PM +0200, Jan Engelhardt wrote:
> 
> On Aug 24 2007 23:04, Adrian Bunk wrote:
> >This patch fixes an annoying bug of export_report.pl missing the usages 
> >of some exports.
> >
> >Signed-off-by: Adrian Bunk <bunk@kernel.org>
> >
> >---
> >
> >This patch has been sent on:
> >- 14 Aug 2007
> >
> >--- a/scripts/export_report.pl
> >+++ b/scripts/export_report.pl
> >@@ -112,7 +112,7 @@ foreach my $thismod (@allcfiles) {
> > 			next;
> > 		}
> > 		if ($state eq 2) {
> 
> Perl: == for numbers, eq for strings.
> SH:   == for strings, -eq for numbers.
> PHP:  == for everything.

I don't care whether it compares strings or numbers as long as it 
works...

I'm not the author of this script, and my patch fixes the one annoying  
bug I observed when using it.

Feel free to improve the script, but that's unrelated to my bugfix.

> >-			if ( $_ !~ /0x[0-9a-f]{7,8},/ ) {
> >+			if ( $_ !~ /0x[0-9a-f]+,/ ) {
> 
> I have not looked closer at it, but this looks like it should be
> /0x[0-9a-fA-F]+,/  or
> /0x[0-9a-f]+,/i
>...

You should have looked closer before sending your email.

> 	Jan

cu
Adrian

-- 

       "Is there not promise of rain?" Ling Tan asked suddenly out
        of the darkness. There had been need of rain for many days.
       "Only a promise," Lao Er said.
                                       Pearl S. Buck - Dragon Seed

