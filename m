Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbYHINsS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbYHINsS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Aug 2008 09:48:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751919AbYHINsD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 9 Aug 2008 09:48:03 -0400
Received: from otello.alma.unibo.it ([137.204.24.163]:42935 "EHLO
	otello.alma.unibo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800AbYHINsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Aug 2008 09:48:00 -0400
X-Greylist: delayed 1229 seconds by postgrey-1.27 at vger.kernel.org; Sat, 09 Aug 2008 09:48:00 EDT
Message-ID: <489D9B46.60001@otello.alma.unibo.it>
Date: Sat, 09 Aug 2008 15:27:34 +0200
From: Diego Zuccato <diego@otello.alma.unibo.it>
User-Agent: Thunderbird 2.0.0.16 (X11/20080725)
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Frans Pop <elendil@planet.nl>, linux-kernel@vger.kernel.org,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-usb@vger.kernel.org
Subject: Re: [regression?] usb: new errors during device detection
References: <Pine.LNX.4.44L0.0808061814250.2145-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0808061814250.2145-100000@iolanthe.rowland.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern ha scritto:

> As each device is enumerated, ehci-hcd determines whether it can run at 
> high speed.  If not, the corresponding switch is set so the device 
> connects back to the UHCI controller and it runs at full/low speed.
Urgh... What happens if it contains a mounted filesystem?
Seems quite dangerous...

BYtE,
  Diego.
