Return-Path: <linux-kernel-owner+w=401wt.eu-S965618AbXCBVCK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965618AbXCBVCK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2007 16:02:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965620AbXCBVCK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Mar 2007 16:02:10 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:44358 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S965618AbXCBVCJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2007 16:02:09 -0500
X-Sasl-enc: sKdncjuH1XjUjENAx23OHdvVmbXxL2fyl+OfYKdEPSH9 1172869326
Date: Fri, 2 Mar 2007 18:01:57 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, romosan@sycorax.lbl.gov,
       linux-kernel@vger.kernel.org, linux-fbdev-devel@lists.sourceforge.net,
       rpurdie@rpsys.net
Subject: Re: 2.6.21-rc2 radeon backlight
Message-ID: <20070302210157.GA11786@khazad-dum.debian.net>
References: <20070301184531.b3aeafe3.akpm@linux-foundation.org> <87tzx35zkc.fsf@sycorax.lbl.gov> <20070302122920.a2967ebf.akpm@linux-foundation.org> <20070302.123514.35465791.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070302.123514.35465791.davem@davemloft.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 Mar 2007, David Miller wrote:
> Why don't we compromise for 2.6.21 by marking the Radeon backlight
> stuff EXPERIMENTAL until the cases where IBM ACPI works and the
> Radeon backlight stuff does not are worked out?

What ibm-acpi backlight control does is *very* different from what the
radeon backlight control does.

ibm-acpi talks to the ThinkPad EC to change the brightness of the backlight,
it has *NO* on/off support.  Radeon talks to the video chipset to turn the
LVDS output on/off (or something to that effect), and thus to turn the
backlight on/off.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
