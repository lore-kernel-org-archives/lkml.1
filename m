Return-Path: <linux-kernel-owner+w=401wt.eu-S1753962AbYIBIIK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962AbYIBIIK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2008 04:08:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751646AbYIBIH4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Sep 2008 04:07:56 -0400
Received: from mail.transmode.se ([83.241.175.147]:47392 "EHLO
	mail.transmode.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437AbYIBIHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2008 04:07:55 -0400
X-Greylist: delayed 632 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Sep 2008 04:07:55 EDT
Subject: Re: [PATCH] usb: add Freescale QE/CPM USB peripheral controller
	driver
From: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Reply-To: joakim.tjernlund@transmode.se
To: Li Yang <leoli@freescale.com>
Cc: avorontsov@ru.mvista.com, greg@kroah.com, linux-usb@vger.kernel.org,
       linux-kernel@vger.kernel.org, dbrownell@users.sourceforge.net,
       linuxppc-dev@ozlabs.org
In-Reply-To: <2a27d3730809020035o52d1feepcde60516c607dac6@mail.gmail.com>
References: <1219916613-28827-1-git-send-email-leoli@freescale.com>
	 <20080901171106.GA13447@oksana.dev.rtsoft.ru>
	 <2a27d3730809020035o52d1feepcde60516c607dac6@mail.gmail.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Organization: Transmode AB
Date: Tue, 02 Sep 2008 09:57:19 +0200
Message-Id: <1220342239.7762.14.camel@gentoo-jocke.transmode.se>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-09-02 at 15:35 +0800, Li Yang wrote:
> On Tue, Sep 2, 2008 at 1:11 AM, Anton Vorontsov
> <avorontsov@ru.mvista.com> wrote:
> > On Thu, Aug 28, 2008 at 05:43:33PM +0800, Li Yang wrote:
> >> Some of Freescale SoC chips have a QE or CPM co-processor which
> >> supports full speed USB.  The driver adds device mode support
> >> of both QE and CPM USB controller to Linux USB gadget.  The
> >> driver is tested with MPC8360 and MPC8272, and should work with
> >> other models having QE/CPM given minor tweaks.
> >>
> >> Signed-off-by: Xie Xiaobo <X.Xie@freescale.com>
> >> Signed-off-by: Li Yang <leoli@freescale.com>
> >> ---
> >> This is the second submission of the driver.  This version addressed:
> >> Comments from Anton Vorontsov.
> >> A lot of cosmetic problem.
> >> Sparse and various kernel DEBUG warnings.
> >
> > Just caught this:
> >
> > g_ether gadget: high speed config #1: CDC Ethernet (ECM)

Does RNDIS work too? If not, is it possible to add or doesn't the HW
support it?

 Jocke
