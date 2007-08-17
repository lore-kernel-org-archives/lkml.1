Return-Path: <linux-kernel-owner+w=401wt.eu-S1757279AbXHQOjj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757279AbXHQOjj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 10:39:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbXHQOja
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 10:39:30 -0400
Received: from mx1.ciphirelabs.net ([217.72.114.64]:44100 "EHLO
	mx.dmz.ciphirelabs.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751781AbXHQOja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 10:39:30 -0400
X-Greylist: delayed 1033 seconds by postgrey-1.27 at vger.kernel.org; Fri, 17 Aug 2007 10:39:30 EDT
From: "Andreas Jellinghaus [c]" <aj@ciphirelabs.com>
To: linux-kernel@vger.kernel.org, linux-usb-devel@lists.sourceforge.net
Subject: why was MODALIAS removed from usb kernel events? [u]
Date: Fri, 17 Aug 2007 16:22:04 +0200
User-Agent: KMail/1.9.6
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708171622.05115.aj@ciphirelabs.com>
X-Ciphire-Security: plain
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=9f8b17e643fe6aa505629658445849397bda4e4f

removes MODALIAS from one of the events, this breaks user space applications 
like openct - everything that depends on getting an event that has both the
DEVICE= path to the usb device and any information on the interface, so it
can check if the device is something it supports (in case of openct:
smart card reader, i.e. bInterfaceClass 0b).

The text does not mention MODALIAS nor the reason for it's removal.

sorry for being late, this problem shows up with 2.6.21 -> 2.6.22 changes.

Andreas
