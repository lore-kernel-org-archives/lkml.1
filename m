Return-Path: <linux-kernel-owner+w=401wt.eu-S1752124AbZLVHKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752124AbZLVHKk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 02:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751867AbZLVHKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 02:10:39 -0500
Received: from mail.gmx.net ([213.165.64.20]:56864 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751747AbZLVHKi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 02:10:38 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1/rimolcAvrBhPikPFcvKsvG6/fY1GWE7G3epX2W8
	11NwMwVwjIVMIP
From: Peter Huewe <PeterHuewe@gmx.de>
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH] char/vme_scc: adding __init macro to vme_scc.c
Date: Tue, 22 Dec 2009 08:10:38 +0100
User-Agent: KMail/1.12.3 (Linux/2.6.27-05415-g69a8594; KDE/4.3.3; x86_64; ; )
Cc: Matheos Worku <Matheos.Worku@sun.com>, Alan Cox <alan@redhat.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <200908202242.31778.PeterHuewe@gmx.de> <4A8DB766.9020701@sun.com> <alpine.LSU.2.00.0910091704010.19284@wotan.suse.de>
In-Reply-To: <alpine.LSU.2.00.0910091704010.19284@wotan.suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200912220810.38336.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.51
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag 09 Oktober 2009 17:04:22 schrieb Jiri Kosina:
> On Thu, 20 Aug 2009, Matheos Worku wrote:
> > > Alan or Geert, please have a look at the small patch and either pull it
> > > through your tree, or please ack' it so Jiri can pull it through the
> > > trivial tree.
> > >
> > > linux version 2.6.31-rc6 - linus git tree, Do 20. Aug 22:26:06 CEST
> > > 2009
> > >
> > > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> > > ---
> > > diff --git a/drivers/char/vme_scc.c b/drivers/char/vme_scc.c
> > > index 994e1a5..8b24729 100644
> > > --- a/drivers/char/vme_scc.c
> > > +++ b/drivers/char/vme_scc.c
> > > @@ -136,7 +136,7 @@ static const struct tty_port_operations
> > > scc_port_ops = { * vme_scc_init() and support functions
> > >  
> > > *----------------------------------------------------------------------
> > >-----*/ -static int scc_init_drivers(void)
> > > +static int __init scc_init_drivers(void)
> > >  {
> > >  	int error;
> > >  @@ -172,7 +172,7 @@ static int scc_init_drivers(void)
> > >  /* ports[] array is indexed by line no (i.e. [0] for ttyS0, [1] for
> > > ttyS1). */
> > >  -static void scc_init_portstructs(void)
> > > +static void __init scc_init_portstructs(void)
> > >  {
> > >  	struct scc_port *port;
> > >  	int i;
> > > @@ -195,7 +195,7 @@ static void scc_init_portstructs(void)
> > >    #ifdef CONFIG_MVME147_SCC
> > > -static int mvme147_scc_init(void)
> > > +static int __init mvme147_scc_init(void)
> > >  {
> > >  	struct scc_port *port;
> > >  	int error;
> > > @@ -298,7 +298,7 @@ fail:
> > >    #ifdef CONFIG_MVME162_SCC
> > > -static int mvme162_scc_init(void)
> > > +static int __init mvme162_scc_init(void)
> > >  {
> > >  	struct scc_port *port;
> > >  	int error;
> > > @@ -404,7 +404,7 @@ fail:
> > >    #ifdef CONFIG_BVME6000_SCC
> > > -static int bvme6000_scc_init(void)
> > > +static int __init bvme6000_scc_init(void)
> > >  {
> > >  	struct scc_port *port;
> > >  	int error;
> > > @@ -503,7 +503,7 @@ fail_free_b_rx:
> > >  #endif
> > >   -static int vme_scc_init(void)
> > > +static int __init vme_scc_init(void)
> > >  {
> > >  	int res = -ENODEV;
> >
> > Then there are issnvram.txt iss.conf etc ... I guess we need to change
> > these as well. How about error messages? I assume they would have ISS in
> > them.
> 
> Confused ... how is this related to the patch?
> 

Hi,

any updates on this one? This patch floats around for quite a while now  
(2009/08/20)

@Matheos: Can you perhaps clearify your remark/objection?


Thanks,
Peter



