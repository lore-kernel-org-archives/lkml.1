Return-Path: <linux-kernel-owner+w=401wt.eu-S1758271AbYB0KST@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758271AbYB0KST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 05:18:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753329AbYB0KSI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 05:18:08 -0500
Received: from ns.firmix.at ([62.141.48.66]:1710 "EHLO ns.firmix.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754174AbYB0KSH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 05:18:07 -0500
Subject: Re: [PATCH] CodingStyle: multiple updates
From: Bernd Petrovitsch <bernd@firmix.at>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       Randy Dunlap <randy.dunlap@oracle.com>, ricknu-0@student.ltu.se,
       khc@pm.waw.pl, bhalevy.lists@gmail.com,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0802271059490.5059@axis700.grange>
References: <1204062430.47c488def40a4@portal.student.luth.se>
	 <20080226135444.f83a0536.randy.dunlap@oracle.com>
	 <Pine.LNX.4.64.0802262310050.15321@fbirervta.pbzchgretzou.qr>
	 <Pine.LNX.4.64.0802270033310.5714@axis700.grange>
	 <1204104420.17396.2.camel@tara.firmix.at>
	 <Pine.LNX.4.64.0802271059490.5059@axis700.grange>
Content-Type: text/plain
Organization: Firmix Software GmbH
Date: Wed, 27 Feb 2008 11:17:44 +0100
Message-Id: <1204107464.17396.20.camel@tara.firmix.at>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.3 (2.8.3-2.fc6) 
Content-Transfer-Encoding: 7bit
X-Firmix-Scanned-By: MIMEDefang 2.56 on ns.firmix.at
X-Firmix-Spam-Score: -2.331 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Spam-Status: No, hits=-2.331 required=5
X-Spam-Score: -2.331 () AWL,BAYES_00,FORGED_RCVD_HELO,SPF_HELO_PASS,SPF_PASS
X-Firmix-Envelope-From: <bernd@firmix.at>
X-Firmix-Envelope-To: <linux-kernel@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mit, 2008-02-27 at 11:02 +0100, Guennadi Liakhovetski wrote:
> On Wed, 27 Feb 2008, Bernd Petrovitsch wrote:
> 
> > On Mit, 2008-02-27 at 00:40 +0100, Guennadi Liakhovetski wrote:
> > > On Tue, 26 Feb 2008, Jan Engelhardt wrote:
> > > 
> > > > +Continuation lines are always shorter than the initial one and are
> > > > +(1) indented as much as the initial line, plus (2) alignment spaces.
> > > > +Spaces are used so as to not cause odd aligning for users wishing to
> > > > +display tabs at sizes other than 8. In the example below, the
> > > > +continuation line of the printk call therefore has two tabs of logical
> > > > +indent, followed by a number of spaces to align it up.
> > > 
> > > Now, I think, I am not the only one using emacs. Until now the "linux" 
> > > C-style fitted perfectly with the CodingStyle, now it no longer will. 
> > > Namely, emacs puts as many tabs to indent the continuation line as fit 
> > > (i.e., at tab width = 8 spaces it's just (extra indent / 8) tabs plus 
> > > (extra indent % 8) spaces. Is there a way to make emacs behave compatibly 
> > > to this proposal? If not, I would not like to have to re-indent every such 
> > 
> > Unless I'm misunderstanding something completely: Add "indent-tabs-mode:
> > nil" in a "Local Variables:" section.
> > But since Linux-style has that since ages (if not ever), that should be
> > set for am emacs'ens linux-mode anyway.
> 
> I think you do misunderstand something. The "linux" emacs mode as I know 

Yes, I`m silly - -ENOCOFFEE;-) CodingStyle/"linux-mode" *does* use TABs
since ever.

> it does for the following example
> 
> 1:	function(arg1,
> 2:		 arg2);
> 
> in line 2 two TABs and one space. Whereas the proposal in discussion wants 
> to have there one TAB and nine spaces.

I stand corrected, you are right.

	Bernd
-- 
Firmix Software GmbH                   http://www.firmix.at/
mobil: +43 664 4416156                 fax: +43 1 7890849-55
          Embedded Linux Development and Services


