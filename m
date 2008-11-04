Return-Path: <linux-kernel-owner+w=401wt.eu-S1754898AbYKDSZH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898AbYKDSZH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2008 13:25:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753391AbYKDSYy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Nov 2008 13:24:54 -0500
Received: from zcars04e.nortel.com ([47.129.242.56]:64665 "EHLO
	zcars04e.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbYKDSYx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2008 13:24:53 -0500
Message-ID: <4910936D.4030605@nortel.com>
Date: Tue, 04 Nov 2008 12:24:45 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Thunderbird 2.0.0.17 (X11/20080914)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [BUG] serial base baud misdetected in 2.6.27
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Nov 2008 18:24:47.0430 (UTC) FILETIME=[9E14DE60:01C93EAA]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I'm running an ATCA7101 board.  This board has two 16550 ports that get 
detected as ttyS4 and ttyS5.

With a much earlier kernel (2.6.14) the serial port base speed is 
correctly detected as 230400, which gives the desired 115200 when I 
specify that on the kernel commandline.

With 2.6.16 and 2.6.27 (not sure about the intervening kernels) the 
serial port base speed is detected as 921600, which means that I need to 
specify 460800 on the commandline to get a real speed of 115200 (as 
verified by an external terminal server).

Any ideas what could be causing this misdetection?  I'm having lab 
issues right now so I can't track it down, but I'll have a go at it 
eventually.

Thanks,

Chris
