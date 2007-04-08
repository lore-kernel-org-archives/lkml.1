Return-Path: <linux-kernel-owner+w=401wt.eu-S1751559AbXDHSHe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbXDHSHe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Apr 2007 14:07:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751602AbXDHSHe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Apr 2007 14:07:34 -0400
Received: from mail.tmr.com ([64.65.253.246]:60978 "EHLO gaimboi.tmr.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751559AbXDHSHe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Apr 2007 14:07:34 -0400
Message-ID: <46192DB7.7030806@tmr.com>
Date: Sun, 08 Apr 2007 14:00:23 -0400
From: Bill Davidsen <davidsen@tmr.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.0.8) Gecko/20061105 SeaMonkey/1.0.6
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: vjn <vjn.raj@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: need help
References: <9868997.post@talk.nabble.com>
In-Reply-To: <9868997.post@talk.nabble.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

vjn wrote:
> in my project i want to code the kernel such that when i plugged my usb it
> should ask for password and check it in the kernel space . can anyone help
> me

I think the correct solution is to use an excrypted mount, and issue the 
mount command manually with the question in user space. There's no code 
to ask for input, nor anyway to positively decide which connected 
terminal is the terminal to ask.

-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
