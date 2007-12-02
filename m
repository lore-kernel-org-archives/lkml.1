Return-Path: <linux-kernel-owner+w=401wt.eu-S1755980AbXLBQVn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755980AbXLBQVn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2007 11:21:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751987AbXLBQVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Dec 2007 11:21:35 -0500
Received: from rtr.ca ([76.10.145.34]:2360 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751451AbXLBQVe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2007 11:21:34 -0500
Message-ID: <4752DB8C.50608@rtr.ca>
Date: Sun, 02 Dec 2007 11:21:32 -0500
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: dmitry.torokhov@gmail.com, rubini@vision.unipv.it,
       linux-input@vger.kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: 2.6.24:  false double-clicks from USB mouse
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've only just recently tried running 2.6.24 on my main machine.
And it appears that I'll have to go back to 2.6.23,
because the USB mouse is not working correctly.

Single-clicking on things with 2.6.24 very frequently gives a "double-click".
This does not happen with 2.6.23.8.

I wonder what broke it?

I've grabbed mousedev.c from 2.6.23 and inserted that in place
of the updated 2.6.24 source, but no change.  So it's not that file.

?????
