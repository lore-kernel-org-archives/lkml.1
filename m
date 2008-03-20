Return-Path: <linux-kernel-owner+w=401wt.eu-S1757946AbYCTXAb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757946AbYCTXAb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 19:00:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753069AbYCTXAY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 19:00:24 -0400
Received: from wf-out-1314.google.com ([209.85.200.170]:46786 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752305AbYCTXAX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 19:00:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=message-id:date:from:to:subject:mime-version:content-type:content-transfer-encoding:content-disposition;
        b=ui8WP6QgpYGkclCqI/x8xSDMmlyiFN76CyGnjhsxofW7zIysACyyYYVlCwDLjj7oc0molEEiLfsUBwOSWMuX93OZKzz0fOVnK9x1m6bpnnYWOQie55DDhzUjca1Lf9RoQZyPig4KNOHkClIR2XKNyKtYOoPOUQpGv6JT/M2sj7c=
Message-ID: <dd18b0c30803201600r1322ddc2gc6eeabacc3817664@mail.gmail.com>
Date: Thu, 20 Mar 2008 23:00:21 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: fglrx
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello;  bob knight
thank you again for helping me out with fglrx, The build did worked
this time, I received an invalid lvalue with cap_t, but was able to
carry through with just using an old capability.h file.
As for the change_page_attr (I dont think I would of ever gotten that)
nice work; here is what dmesg says:

[    8.823442] Symbol init_mm is marked as UNUSED, however this module
is using it.
[    8.823446] This symbol will go away in the future.
[    8.823448] Please evalute if this is the right api to use, and if
it really is, submit a report the linux kernel mailinglist together
with submitting your code for inclusion.
[    8.842105] [fglrx] Maximum main memory to use for locked dma
buffers: 913 MBytes.
[    8.842133] [fglrx] ASYNCIO init succeed!
[    8.843985] [fglrx] PAT is enabled successfully!
[    8.844006] [fglrx] module loaded - fglrx 8.47.3 [Feb 25 2008] on minor 0
[   54.527129] [fglrx] Reserve Block - 0 offset =  0X7ffb000 length = 0X5000
[   54.527135] [fglrx] Reserve Block - 1 offset =  0X0 length = 0X1000000
[   54.527138] [fglrx] Reserve Block - 2 offset =  0X7fbb000 length = 0X40000
[   54.785599] [fglrx] interrupt source 20008000 successfully enabled
[   54.785599] [fglrx] enable ID = 0x00000008
[   54.785599] [fglrx] Receive enable interrupt message with
irqEnableMask: 20008000
[   54.785599] [fglrx] interrupt source 10000000 successfully enabled
[   54.785599] [fglrx] enable ID = 0x00000009
[   54.785599] [fglrx] Receive enable interrupt message with
irqEnableMask: 10000000

I looked on google but didnt find much about init_mm
I'll paste what you gave me on the mactel site so anybody who needs
fglrx on 2.6.25 can get it working to somewhat of an extent.
regards;


-- 
Justin P. Mattock
