Return-Path: <linux-kernel-owner+w=401wt.eu-S1758020AbXFMK1R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758020AbXFMK1R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2007 06:27:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756951AbXFMK1I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jun 2007 06:27:08 -0400
Received: from pollux.ds.pg.gda.pl ([153.19.208.7]:3481 "EHLO
	pollux.ds.pg.gda.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756701AbXFMK1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2007 06:27:06 -0400
Date: Wed, 13 Jun 2007 11:27:03 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
cc: David Schwartz <davids@webmaster.com>,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: PC speaker
In-Reply-To: <Pine.LNX.4.64.0706122223350.19578@fbirervta.pbzchgretzou.qr>
Message-ID: <Pine.LNX.4.64N.0706131119010.7198@blysk.ds.pg.gda.pl>
References: <MDEHLPKNGKAHNMBLJOLKKEHOEIAC.davids@webmaster.com>
 <Pine.LNX.4.64.0706122223350.19578@fbirervta.pbzchgretzou.qr>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 12 Jun 2007, Jan Engelhardt wrote:

> >4) It assumes the current will be sufficient to burn out the speaker. (I
> >know it will get very hot on older machines, whether it will burn out --
> >might even depend on the exact speaker model.)
> 
> Since you can set the x86's crystals frequency from 1193182 to 18 Hz
> (PIT_TICK_RATE / 1 to PIT_TICK_RATE / 65535) [*], you can never really
> bust it. But even then, what would a speaker do it was constanly given

 I am fairly sure you have a choice between a steady low and a steady high 
level on the speaker output available if you switch the 8254 to the right 
single-shot mode.  In case you have not been into such details -- the 8254 
offers six modes of operation, selected for each channel separately, of 
which only two are periodic.

  Maciej
