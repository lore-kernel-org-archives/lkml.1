Return-Path: <linux-kernel-owner+w=401wt.eu-S1753849AbXLDMHO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849AbXLDMHO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 07:07:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbXLDMHA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 07:07:00 -0500
Received: from smtpoutm.mac.com ([17.148.16.71]:55704 "EHLO smtpoutm.mac.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbXLDMG7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 07:06:59 -0500
In-Reply-To: <20071202184544.GK6372@mea-ext.zmailer.org>
References: <a71bd89a0711290713w809db6fv933ee9d9744bab6c@mail.gmail.com> <1196350632.20567.191.camel@skunk.anacadf.mentorg.com> <a71bd89a0711290746q57002217ga14c4f4f7201683d@mail.gmail.com> <20071202184544.GK6372@mea-ext.zmailer.org>
Mime-Version: 1.0 (Apple Message framework v752.2)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Message-Id: <66743335-0E47-4443-B550-2BCC80A11A93@mac.com>
Cc: Dan Kegel <dank@kegel.com>, linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
From: Kyle Moffett <mrmacman_g4@mac.com>
Subject: Re: Relax permissions for reading hard drive serial number?
Date: Tue, 4 Dec 2007 07:06:52 -0500
To: Matti Aarnio <matti.aarnio@zmailer.org>
X-Mailer: Apple Mail (2.752.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 02, 2007, at 13:45:44, Matti Aarnio wrote:
> This lack of having stable(*) unique system identifier available to  
> applications is one of the small details that make node locked  
> commercial software delivery challenging thing in UNIX environments..
>
> *) "stable" as both stable data, and stable API to get it.

Well... There's that.  There's also the fact that anybody with a  
modicum of ASM programming skills can get clever with GDB and traces  
from "Correct HW serial" and "Incorrect HW serial" can write a 10- 
line GDB script to make it work regardless.  I did something similar  
with a popular FPS (which I legitimately own) on one of my Mac  
systems after having left the DVD behind when going to a LAN party.   
Addresses removed to protect the innocent^Wguilty, but they took  
maybe 15 minutes to acquire:

break *END_OF_CDKEY_CODE_DECRYPTION
run
delete 1
advance *JUST_AFTER_CDKEY_CHECK
set $r3 = 0
detach

At some point every such "locked" computer program has code like this:
> if (program_is_not_authorized()) {
>     display_nasty_dialog();
>     exit(1);
> }

All it takes for somebody with a debugger is to identify the last  
instruction of the "program_is_authorized()" function and change $r3  
(or whatever return register your system uses) from a 1 to a 0.  The  
fact remains that once the software is running on *THEIR* computer  
there is nothing you can practically do to forcibly prevent them from  
using it in whatever fashion they desire.  Typically if you price  
your software reasonably people will be willing to pay for multiple  
copies but there are no foolproof technical measures to enforce that  
they do so.

Cheers,
Kyle Moffett

