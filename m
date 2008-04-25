Return-Path: <linux-kernel-owner+w=401wt.eu-S1760903AbYDYIDg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760903AbYDYIDg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2008 04:03:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757565AbYDYIDT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Apr 2008 04:03:19 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:37216 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756923AbYDYIDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2008 04:03:16 -0400
From: "Takashi Nishiie" <t-nishiie@np.css.fujitsu.com>
To: <fox@crisp.demon.co.uk>, <bart.vanassche@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
References: <200804211958.m3LJw6QM004827@crisp.demon.co.uk>
In-Reply-To: <200804211958.m3LJw6QM004827@crisp.demon.co.uk>
Subject: RE: dtrace for linux
Date: Fri, 25 Apr 2008 17:03:11 +0900
Message-ID: <000e01c8a6aa$ce638960$6b2a9c20$@css.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-Index: Acij6mkK4PKrBODIRJe0AJb7If9vvwCv9HUQ
Content-Language: ja
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> On Sun, Apr 20, 2008 at 1:17 AM,  <fox@crisp.demon.co.uk> wrote:
>>>
>>>  I would like to announce that I am working on dtrace for Linux.
>>>  I have the userland dtrace binary compiled, along with the first
>>>  pre-pre-alpha dtracedrv.ko module loaded into my kernel.
>> 
>> This is great news. How will this dtrace implementation differ from
>> SystemTap (http://sourceware.org/systemtap/) ?
>> 
>> Bart.
>> 
>> 
>
>Hello Bart,
>
>
>I dont know systemtap all that well, other than what i have
>read on the net and browsed in the source. systemtap is similar,
>but dtrace provides a high level functional language (D) and
>a set of methodologies and scripts which mean learning/training
>will make it easier to use.

Hello,

  SystemTAP is the tool developed in order to do the same thing 
as Dtrace. When development of SystemTAP started, Dtrace was not
 able to be used with restriction by the license at linux. The 
difference in both SystemTAP and Dtrace is produced by avoiding 
being based on mounting peculiar to linux, and a license.

  By the way, aren't any ideas found in order to mitigate the 
load when acquiring trace? If load when having taken trace as 
for LTTng as for SystemTAP is too heavy, I feel. For example, 
it is desirable that trace with lighter load can be taken by the
 limiting conditions of obtaining the trace result only for 
several seconds until panic occurs. 

Regards



