Return-Path: <linux-kernel-owner+w=401wt.eu-S1760771AbYBEUza@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760771AbYBEUza (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2008 15:55:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755392AbYBEUzX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Feb 2008 15:55:23 -0500
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:56894
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755231AbYBEUzW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2008 15:55:22 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: linux-kernel@vger.kernel.org
Subject: 2.6.24 says "serial8250: too much work for irq4" a lot.
Date: Tue, 5 Feb 2008 14:55:10 -0600
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802051455.10831.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When running a 2.6.24 kernel built for x86-64 under qemu via serial console, 
doing CPU-intensive things that also produce a lot of output (such as 
compiling software) tends to produce the error message in the title.

Anybody have a clue why?  It doesn't seem to cause an actual problem, but it's 
kind of annoying.

(If it's a qemu issue, I can go bother them.  It's possible that qemu isn't 
delivering interrupts as often as it expects, since that's limited by the 
granularity of the host timer; I know the clock in qemu can run a bit slow 
because it only gets clock interrupts when the host system isn't too busy to 
schedule the emulator.  But this doesn't usually cause a problem.  I _think_ 
the message is just a "this should never happen" type warning, which is 
happening to me.  But I break stuff. :)

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
