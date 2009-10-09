Return-Path: <linux-kernel-owner+w=401wt.eu-S1758890AbZJIPFC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758890AbZJIPFC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 11:05:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758241AbZJIPFB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 11:05:01 -0400
Received: from cantor.suse.de ([195.135.220.2]:46090 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756472AbZJIPFA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 11:05:00 -0400
Date: Fri, 9 Oct 2009 17:04:22 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jkosina@wotan.suse.de
To: Matheos Worku <Matheos.Worku@Sun.COM>
Cc: Peter Huewe <PeterHuewe@gmx.de>, Alan Cox <alan@redhat.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] char/vme_scc: adding __init macro to vme_scc.c
In-Reply-To: <4A8DB766.9020701@sun.com>
Message-ID: <alpine.LSU.2.00.0910091704010.19284@wotan.suse.de>
References: <200908202242.31778.PeterHuewe@gmx.de> <4A8DB766.9020701@sun.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 20 Aug 2009, Matheos Worku wrote:

> > Alan or Geert, please have a look at the small patch and either pull it
> > through your tree, or please ack' it so Jiri can pull it through the trivial
> > tree.
> > 
> > linux version 2.6.31-rc6 - linus git tree, Do 20. Aug 22:26:06 CEST 2009
> > 
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> > ---
> > diff --git a/drivers/char/vme_scc.c b/drivers/char/vme_scc.c
> > index 994e1a5..8b24729 100644
> > --- a/drivers/char/vme_scc.c
> > +++ b/drivers/char/vme_scc.c
> > @@ -136,7 +136,7 @@ static const struct tty_port_operations scc_port_ops = {
> >   * vme_scc_init() and support functions
> >   *---------------------------------------------------------------------------*/
> >  -static int scc_init_drivers(void)
> > +static int __init scc_init_drivers(void)
> >  {
> >  	int error;
> >  @@ -172,7 +172,7 @@ static int scc_init_drivers(void)
> >  /* ports[] array is indexed by line no (i.e. [0] for ttyS0, [1] for ttyS1).
> >   */
> >  -static void scc_init_portstructs(void)
> > +static void __init scc_init_portstructs(void)
> >  {
> >  	struct scc_port *port;
> >  	int i;
> > @@ -195,7 +195,7 @@ static void scc_init_portstructs(void)
> >    #ifdef CONFIG_MVME147_SCC
> > -static int mvme147_scc_init(void)
> > +static int __init mvme147_scc_init(void)
> >  {
> >  	struct scc_port *port;
> >  	int error;
> > @@ -298,7 +298,7 @@ fail:
> >    #ifdef CONFIG_MVME162_SCC
> > -static int mvme162_scc_init(void)
> > +static int __init mvme162_scc_init(void)
> >  {
> >  	struct scc_port *port;
> >  	int error;
> > @@ -404,7 +404,7 @@ fail:
> >    #ifdef CONFIG_BVME6000_SCC
> > -static int bvme6000_scc_init(void)
> > +static int __init bvme6000_scc_init(void)
> >  {
> >  	struct scc_port *port;
> >  	int error;
> > @@ -503,7 +503,7 @@ fail_free_b_rx:
> >  #endif
> >   -static int vme_scc_init(void)
> > +static int __init vme_scc_init(void)
> >  {
> >  	int res = -ENODEV;
> Then there are issnvram.txt iss.conf etc ... I guess we need to change 
> these as well. How about error messages? I assume they would have ISS in 
> them.

Confused ... how is this related to the patch?

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
