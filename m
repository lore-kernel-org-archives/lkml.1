Return-Path: <linux-kernel-owner+w=401wt.eu-S934460AbXHHOd1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934460AbXHHOd1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2007 10:33:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752715AbXHHOdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Aug 2007 10:33:19 -0400
Received: from sour.ops.eusc.inter.net ([84.23.254.154]:51738 "EHLO
	sour.ops.eusc.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825AbXHHOdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2007 10:33:18 -0400
X-Greylist: delayed 1449 seconds by postgrey-1.27 at vger.kernel.org; Wed, 08 Aug 2007 10:33:18 EDT
X-Trace: 4d7c73656261737469616e2e6b6c6f736b6140736e6166752e64657c38352e3137
	382e39372e36347c3149496d446a2d3030304277452d4e527c3131383635383231
	3437
Message-ID: <46B9CE82.1050000@snafu.de>
Date: Wed, 08 Aug 2007 16:09:06 +0200
From: Oncaphillis <oncaphillis@snafu.de>
Reply-To: oncaphillis@snafu.de
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: UART misbehaves under Linkstation/KuroBoxHG 
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Greetings,

I'm trying to compile a 2.6.2x kernel on a Linkstation/KuroBox HG/ppc
following instructions given under 
http://www.kurobox.com/mwiki/index.php/Kurobox_support_in_stock_2.6_kernels 
and get weired settings and errors from the serial device (UART 16550A).

Under the 2.4.17 kernel provided by the Kurobox manufacturer it gets 
IRQS in the range of 137/138 under 2.6.22 for the linkstation it gets 
IRQS 17/18 and the serial device behaves fishy

communication errors

"to much work in IRQ 16"

stty -F /dev/ttyS0 sometimes tells me
"unable to perform all requested operations"

setserial tells me the port for /dev/ttyS0 is 0x000 (?)
while cat /proc/tty/driver/serial reports the proper mmio
0x80004500

This holds true for 2.6.20 and 2.6.22.1

Any suggestions ?

Thanks for listening.

