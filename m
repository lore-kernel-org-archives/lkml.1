Return-Path: <linux-kernel-owner+w=401wt.eu-S1761083AbYEAN5A@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761083AbYEAN5A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2008 09:57:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757948AbYEAN4x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 May 2008 09:56:53 -0400
Received: from smtp.eu.citrix.com ([62.200.22.115]:53123 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755498AbYEAN4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2008 09:56:52 -0400
X-IronPort-AV: E=Sophos;i="4.27,422,1204520400"; 
   d="scan'208";a="14074503"
Date: Thu, 1 May 2008 14:19:00 +0100
From: Samuel Thibault <samuel.thibault@ens-lyon.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, akpm@osdl.org, torvalds@osdl.org
Subject: Re: This month's price for the most useless new Kconfig help text ...
Message-ID: <20080501131900.GL4797@implementation.uk.xensource.com>
Mail-Followup-To: Samuel Thibault <samuel.thibault@ens-lyon.org>,
	Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
	akpm@osdl.org, torvalds@osdl.org
References: <20080501120959.GA16700@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20080501120959.GA16700@basil.nowhere.org>
User-Agent: Mutt/1.5.12-2006-07-14
X-OriginalArrivalTime: 01 May 2008 13:56:48.0046 (UTC) FILETIME=[32C654E0:01C8AB93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen, le Thu 01 May 2008 14:09:59 +0200, a écrit :
> <drumroll> ... gets CONFIG_ACCESSIBILITY
> 
> menuconfig ACCESSIBILITY
>         bool "Accessibility support"
>         ---help---
>           Enable a submenu where accessibility items may be enabled.
> 
> Can the help text be improved please? It should explain that accessibility in 
> this case means braille device drivers and possibly other similar devices.

If the society was a bit more aware of accessibility troubles in general
(I mean in the street etc.), we wouldn't have to explain the word
</grin>.

Samuel



Add a small explanation of what accessibility is.

Signed-off-by: Samuel Thibault <samuel.thibault@ens-lyon.org>

--- linux/drivers/accessibility/Kconfig.orig	2008-05-01 14:13:03.000000000 +0100
+++ linux/drivers/accessibility/Kconfig	2008-05-01 14:12:50.000000000 +0100
@@ -3,6 +3,13 @@
 	---help---
 	  Enable a submenu where accessibility items may be enabled.
 
+	  Accessibility handles all special kinds of hardware devices or
+	  software adapters which help people with disabilities (e.g.
+	  blindness) to use computers.
+
+	  That includes braille devices, speech synthesis, keyboard
+	  remapping, etc.
+
 	  If unsure, say N.
 
 if ACCESSIBILITY
