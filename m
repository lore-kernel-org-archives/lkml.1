Return-Path: <linux-kernel-owner+w=401wt.eu-S1753914AbZI2M0e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753914AbZI2M0e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 08:26:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753955AbZI2M0e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 08:26:34 -0400
Received: from mail.gmx.net ([213.165.64.20]:32975 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753989AbZI2M0d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 08:26:33 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+DxvFMVlmD/sg7d9nS0LnH2PuqbqMGgSjplJJBJt
	rjWsFos0z/x6lX
From: Peter =?iso-8859-1?q?H=FCwe?= <PeterHuewe@gmx.de>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] char/vme_scc: adding __init macro to vme_scc.c
Date: Tue, 29 Sep 2009 14:26:33 +0200
User-Agent: KMail/1.9.10
Cc: Jiri Kosina <trivial@kernel.org>,
       Geert Uytterhoeven <geert@linux-m68k.org>, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
References: <200908202242.31778.PeterHuewe@gmx.de> <200908202301.13974.PeterHuewe@gmx.de>
In-Reply-To: <200908202301.13974.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200909291426.34315.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.52
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thursday 20 August 2009 23:01:13 schrieb Peter Huewe:
> Am Donnerstag 20 August 2009 22:42:31 schrieb Peter Huewe:
> > From: Peter Huewe <peterhuewe@gmx.de>
> >
> > Trivial patch which adds the __init macro to the module_init
> > function and all of its helper functions of char/vme_scc.c
> >
> > Alan or Geert, please have a look at the small patch and either pull it
> > through your tree, or please ack' it so Jiri can pull it through the
> > trivial tree.
> >
> > linux version 2.6.31-rc6 - linus git tree, Do 20. Aug 22:26:06 CEST 2009
> >
> > Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> > ---
> > diff --git a/drivers/char/vme_scc.c b/drivers/char/vme_scc.c
> > index 994e1a5..8b24729 100644
> > --- a/drivers/char/vme_scc.c
> > +++ b/drivers/char/vme_scc.c
> > @@ -136,7 +136,7 @@ static const struct tty_port_operations scc_port_ops
> > = { * vme_scc_init() and support functions
> >
> > *------------------------------------------------------------------------
> >-- -*/
> >
> > -static int scc_init_drivers(void)
> > +static int __init scc_init_drivers(void)
> >  {
> >  	int error;
> >
> > @@ -172,7 +172,7 @@ static int scc_init_drivers(void)
> >  /* ports[] array is indexed by line no (i.e. [0] for ttyS0, [1] for
> > ttyS1). */
> >
> > -static void scc_init_portstructs(void)
> > +static void __init scc_init_portstructs(void)
> >  {
> >  	struct scc_port *port;
> >  	int i;
> > @@ -195,7 +195,7 @@ static void scc_init_portstructs(void)
> >
> >
> >  #ifdef CONFIG_MVME147_SCC
> > -static int mvme147_scc_init(void)
> > +static int __init mvme147_scc_init(void)
> >  {
> >  	struct scc_port *port;
> >  	int error;
> > @@ -298,7 +298,7 @@ fail:
> >
> >
> >  #ifdef CONFIG_MVME162_SCC
> > -static int mvme162_scc_init(void)
> > +static int __init mvme162_scc_init(void)
> >  {
> >  	struct scc_port *port;
> >  	int error;
> > @@ -404,7 +404,7 @@ fail:
> >
> >
> >  #ifdef CONFIG_BVME6000_SCC
> > -static int bvme6000_scc_init(void)
> > +static int __init bvme6000_scc_init(void)
> >  {
> >  	struct scc_port *port;
> >  	int error;
> > @@ -503,7 +503,7 @@ fail_free_b_rx:
> >  #endif
> >
> >
> > -static int vme_scc_init(void)
> > +static int __init vme_scc_init(void)
> >  {
> >  	int res = -ENODEV;
>
> Forwarded message to Alan Cox <alan@lxorguk.ukuu.org.uk>, as
> alan@redhat.com - as reported by get_maintainer.pl does not work anymore.


Hmm any updates on this one?

Thanks,
Peter

