Return-Path: <linux-kernel-owner+w=401wt.eu-S1757409AbZKKPbj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757409AbZKKPbj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Nov 2009 10:31:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756348AbZKKPbj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Nov 2009 10:31:39 -0500
Received: from imap.ru.mvista.com ([213.79.90.228]:4209 "EHLO
	buildserver.ru.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754440AbZKKPbi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Nov 2009 10:31:38 -0500
Date: Wed, 11 Nov 2009 18:31:43 +0300
From: Anton Vorontsov <avorontsov@ru.mvista.com>
To: Paul Fertser <fercerpav@gmail.com>
Cc: Ben Dooks <ben@simtec.co.uk>, Anton Vorontsov <cbou@mail.ru>,
       David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>, Lars-Peter Clausen <lars@metafoo.de>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [PATCH 3/6] gta02: set pcf50633 charger_reference_current_ma
Message-ID: <20091111153143.GA1610@oksana.dev.rtsoft.ru>
Reply-To: avorontsov@ru.mvista.com
References: <1257369899-325-1-git-send-email-fercerpav@gmail.com>
 <1257369899-325-2-git-send-email-fercerpav@gmail.com>
 <1257369899-325-3-git-send-email-fercerpav@gmail.com>
 <20091111134844.GB22476@home.pavel.comp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20091111134844.GB22476@home.pavel.comp>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 11, 2009 at 04:48:44PM +0300, Paul Fertser wrote:
> Hi,
> 
> Ben, please give us an advice on how to proceed with this rather
> trivial patch. Anton doesn't merge the other patches from this series
> because we do not know via which tree to merge this particular patch.

Paul, I'll just merge the whole patch set but skip this particular
patch.

Thanks,

> On Thu, Nov 05, 2009 at 12:24:56AM +0300, Paul Fertser wrote:
> > From: Lars-Peter Clausen <lars@metafoo.de>
> > 
> > This value is board-specific and is needed for calculations to set charging
> > current limit properly.
> > 
> > Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> > Acked-by: Nelson Castillo <arhuaco@freaks-unidos.net>
> > Signed-off-by: Paul Fertser <fercerpav@gmail.com>
> > Cc: Russell King <rmk+kernel@arm.linux.org.uk>
> > ---
> > 
> > Since this patch compile-depends on previous probably it should go through
> > the same tree as others. Nelson (gta02 maintainer) agrees with whatever you
> > think is best.
> > 
> > Anton Vorontsov is ok with merging it through his tree but needs an explicit
> > ack.
> > 
> >  arch/arm/mach-s3c2442/mach-gta02.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/arch/arm/mach-s3c2442/mach-gta02.c b/arch/arm/mach-s3c2442/mach-gta02.c
> > index 0fb385b..b0a3d74 100644
> > --- a/arch/arm/mach-s3c2442/mach-gta02.c
> > +++ b/arch/arm/mach-s3c2442/mach-gta02.c
> > @@ -268,6 +268,9 @@ struct pcf50633_platform_data gta02_pcf_pdata = {
> >  
> >  	.batteries = gta02_batteries,
> >  	.num_batteries = ARRAY_SIZE(gta02_batteries),
> > +
> > +	.charger_reference_current_ma = 1000,
> > +
> >  	.reg_init_data = {
> >  		[PCF50633_REGULATOR_AUTO] = {
> >  			.constraints = {
> > -- 
> > 1.6.4.4
> > 
> 
> -- 
> Be free, use free (http://www.gnu.org/philosophy/free-sw.html) software!
> mailto:fercerpav@gmail.com
> 

-- 
Anton Vorontsov
email: cbouatmailru@gmail.com
irc://irc.freenode.net/bd2
