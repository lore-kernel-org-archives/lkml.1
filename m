Return-Path: <linux-kernel-owner+w=401wt.eu-S1764680AbYEASiN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764680AbYEASiN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 14:38:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755407AbYEASh7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 14:37:59 -0400
Received: from mtaout03-winn.ispmail.ntl.com ([81.103.221.49]:58994 "EHLO
	mtaout03-winn.ispmail.ntl.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753357AbYEASh6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 14:37:58 -0400
Date: Thu, 1 May 2008 19:37:51 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@osdl.org, torvalds@osdl.org
Subject: Re: This month's price for the most useless new Kconfig help text ...
Message-ID: <20080501183750.GA4785@implementation>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Stefan Richter <stefanr@s5r6.in-berlin.de>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	akpm@osdl.org, torvalds@osdl.org
References: <20080501120959.GA16700@basil.nowhere.org> <20080501131900.GL4797@implementation.uk.xensource.com> <4819FF99.6020504@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4819FF99.6020504@s5r6.in-berlin.de>
User-Agent: Mutt/1.5.12-2006-07-14
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter, le Thu 01 May 2008 19:36:25 +0200, a écrit :
> Samuel Thibault wrote:
> >--- linux/drivers/accessibility/Kconfig.orig	2008-05-01 
> >14:13:03.000000000 +0100
> >+++ linux/drivers/accessibility/Kconfig	2008-05-01 
> >14:12:50.000000000 +0100
> >@@ -3,6 +3,13 @@
> > 	---help---
> > 	  Enable a submenu where accessibility items may be enabled.
> > 
> >+	  Accessibility handles all special kinds of hardware devices or
> >+	  software adapters which help people with disabilities (e.g.
> >+	  blindness) to use computers.
> >+
> >+	  That includes braille devices, speech synthesis, keyboard
> >+	  remapping, etc.
> >+
> > 	  If unsure, say N.
> 
> Would you mind replacing also the first sentence by something which 
> indicates whether this option alone already changes the kernel build?

Here it is.

Samuel



Indicate that enabling just CONFIG_ACCESSIBILITY does not add code.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

--- linux/drivers/accessibility/Kconfig.orig	2008-05-01 19:34:11.000000000 +0100
+++ linux/drivers/accessibility/Kconfig	2008-05-01 19:35:56.000000000 +0100
@@ -1,8 +1,6 @@
 menuconfig ACCESSIBILITY
 	bool "Accessibility support"
 	---help---
-	  Enable a submenu where accessibility items may be enabled.
-
 	  Accessibility handles all special kinds of hardware devices or
 	  software adapters which help people with disabilities (e.g.
 	  blindness) to use computers.
@@ -10,6 +8,11 @@
 	  That includes braille devices, speech synthesis, keyboard
 	  remapping, etc.
 
+	  Say Y here to get to see options for accessibility.
+	  This option alone does not add any kernel code.
+
+	  If you say N, all options in this submenu will be skipped and disabled.
+
 	  If unsure, say N.
 
 if ACCESSIBILITY
