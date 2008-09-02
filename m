Return-Path: <linux-kernel-owner+w=401wt.eu-S1754019AbYIBIPt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754019AbYIBIPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 04:15:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751510AbYIBIPc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 04:15:32 -0400
Received: from mail.transmode.se ([83.241.175.147]:47790 "EHLO
	mail.transmode.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751276AbYIBIPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 04:15:31 -0400
Subject: RE: [PATCH] usb: add Freescale QE/CPM USB peripheral
	controllerdriver
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Reply-To: joakim.tjernlund@transmode.se
To: Li Yang-R58472 <LeoLi@freescale.com>
Cc: avorontsov@ru.mvista.com, greg@kroah.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       linuxppc-dev@ozlabs.org
In-Reply-To: <0C69E0CDED15E4469A445DE244C1B9F708CEE6@zch01exm26.fsl.freescale.net>
References: <1219916613-28827-1-git-send-email-leoli@freescale.com>
	 <20080901171106.GA13447@oksana.dev.rtsoft.ru>
	 <2a27d3730809020035o52d1feepcde60516c607dac6@mail.gmail.com>
	 <1220342239.7762.14.camel@gentoo-jocke.transmode.se>
	 <0C69E0CDED15E4469A445DE244C1B9F708CEE6@zch01exm26.fsl.freescale.net>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Transmode AB
Date: Tue, 02 Sep 2008 10:15:29 +0200
Message-Id: <1220343329.7762.23.camel@gentoo-jocke.transmode.se>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-02 at 16:12 +0800, Li Yang-R58472 wrote:
> > -----Original Message-----
> > From: Joakim Tjernlund [mailto:joakim.tjernlund@transmode.se] 
> > Sent: Tuesday, September 02, 2008 3:57 PM
> > To: Li Yang-R58472
> > Cc: avorontsov@ru.mvista.com; greg@kroah.com; 
> > linux-usb@vger.kernel.org; linux-kernel@vger.kernel.org; 
> > dbrownell@users.sourceforge.net; linuxppc-dev@ozlabs.org
> > Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral 
> > controllerdriver
> > 
> > On Tue, 2008-09-02 at 15:35 +0800, Li Yang wrote:
> > > On Tue, Sep 2, 2008 at 1:11 AM, Anton Vorontsov 
> > > <avorontsov@ru.mvista.com> wrote:
> > > > On Thu, Aug 28, 2008 at 05:43:33PM +0800, Li Yang wrote:
> > > >> Some of Freescale SoC chips have a QE or CPM co-processor which 
> > > >> supports full speed USB.  The driver adds device mode support of 
> > > >> both QE and CPM USB controller to Linux USB gadget.  The 
> > driver is 
> > > >> tested with MPC8360 and MPC8272, and should work with 
> > other models 
> > > >> having QE/CPM given minor tweaks.
> > > >>
> > > >> Signed-off-by: Xie Xiaobo <X.Xie@freescale.com>
> > > >> Signed-off-by: Li Yang <leoli@freescale.com>
> > > >> ---
> > > >> This is the second submission of the driver.  This 
> > version addressed:
> > > >> Comments from Anton Vorontsov.
> > > >> A lot of cosmetic problem.
> > > >> Sparse and various kernel DEBUG warnings.
> > > >
> > > > Just caught this:
> > > >
> > > > g_ether gadget: high speed config #1: CDC Ethernet (ECM)
> > 
> > Does RNDIS work too? If not, is it possible to add or doesn't 
> > the HW support it?
> 
> RNDIS is a gadget(protocol) level thing.  I believe it can work with
> this driver although not tested myself.
> 
> Noted:  AFAIK, RNDIS gadget in Linux doesn't interoperate with windows
> well enough to be production level.  Use at your own risk.

I see. If one wants to connect with CDC to Windows, what drivers are
there for Windows that works well with Linux?

 Jocke 
