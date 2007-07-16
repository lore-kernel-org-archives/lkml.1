Return-Path: <linux-kernel-owner+w=401wt.eu-S1761616AbXGPNXR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761616AbXGPNXR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2007 09:23:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756125AbXGPNXG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jul 2007 09:23:06 -0400
Received: from mu-out-0910.google.com ([209.85.134.184]:39834 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757977AbXGPNXF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2007 09:23:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:subject:content-type:content-transfer-encoding:from;
        b=d0WNTEng0SMWh9QxjiVbMQRYftVsE5t6Yh86J1ruipgqyHC4cLZ1ruv5u93ZLgoSV6zjM4ezxUE6wv2I04pWJxK/GQYMTdTgzTZ3KSKI0dW7VQvvtwl8oo4F2wdMBlyrOlrgw/Htl6nvxNh6pZNinKQNdemSD42+ounUDo8j+/I=
Message-ID: <469B712D.80208@googlemail.com>
Date: Mon, 16 Jul 2007 14:22:53 +0100
User-Agent: Thunderbird 2.0.0.4 (X11/20070604)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: try_module_get question
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: Robert Beckett <bob.beckett@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Im a newcomer to kernel development, and have my first question :

I want to create a small module that simply powers on an FPGA, and 
powers it off when it is released. Two other modules will then depend on 
this module and control different devices programmed into the FPGA. So 
that the shared module does not get removed before any of the device 
drivers, I want to do a try_module_get from each driver targeting the 
shared module. What is the easiest way to get a reference to the shared 
module?

My current thought is to export a function that will return a reference 
to it (using THIS_MODULE from the shared module). The device driver 
modules can then try_module_get the returned module. Is this the best 
way to do this?

Is there an alternative way? maybe based on a similar system to the 
device / driver matching code?
There seem to be a lot of FAQs online saying that you need to get and 
put a module before calling any function that may stall for example, but 
they dont tell you how to get the module reference to use.

Or am I just missing something obvious?

Thanks

Robert Beckett.
