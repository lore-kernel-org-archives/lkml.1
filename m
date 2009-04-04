Return-Path: <linux-kernel-owner+w=401wt.eu-S1756754AbZDDVKn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756754AbZDDVKn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Apr 2009 17:10:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752874AbZDDVKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Apr 2009 17:10:34 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:47684 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751866AbZDDVKe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Apr 2009 17:10:34 -0400
Message-ID: <49D7CCBA.60301@garzik.org>
Date: Sat, 04 Apr 2009 17:10:18 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Mark Lord <lkml@rtr.ca>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Chris Mason <chris.mason@oracle.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Rees <drees76@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
References: <1238758370.32764.5.camel@think.oraclecorp.com> <alpine.LFD.2.00.0904030804160.4130@localhost.localdomain> <49D66C0E.5090301@garzik.org> <49D7564A.9090409@rtr.ca>
In-Reply-To: <49D7564A.9090409@rtr.ca>
Content-Type: multipart/mixed;
 boundary="------------010201000302000700050800"
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.5 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010201000302000700050800
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Mark Lord wrote:
> Jeff Garzik wrote:
>>
>> I've attached 'hdparm -I' in case anyone is curious.  It's from 
>> newegg.com, so nothing NDA'd or sekrit.
>>
>> ATA device, with non-removable media
>>     Model Number:       G.SKILL 128GB SSD                       
>>     Serial Number:      MK0108480A545003B       Firmware Revision:  
>> 02.10104
>> Standards:
>>     Used: ATA/ATAPI-7 T13 1532D revision 4a     Supported: 8 7 6 5 & 
>> some of 8
>> Configuration:
>>     Logical        max    current
>>     cylinders    16383    16383
>>     heads        16    16
>>     sectors/track    63    63
>>     --
>>     CHS current addressable sectors:   16514064
>>     LBA    user addressable sectors:  250445824
>>     device size with M = 1024*1024:      122288 MBytes
>>     device size with M = 1000*1000:      128228 MBytes (128 GB)
> ..
> 
> That's odd.  I kind of expected to see the sector size,
> cache size, and perhaps media rotation rate reported there..
> Can you update your hdparm (sourceforge) and repost?
> 
> There might be other useful features of that drive,
> which some of us are quite curious to know about!  :)

Here's output of hdparm 9.12, from Fedora rawhide.

I was unaware that both read-ahead and writeback caching were disabling 
on this drive, until that was pointed out to me in email.  huh.

I'll have to redo my tests...

	Jeff




--------------010201000302000700050800
Content-Type: text/plain;
 name="ssd-hdparm.txt"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="ssd-hdparm.txt"

Ci9kZXYvc2RiOgoKQVRBIGRldmljZSwgd2l0aCBub24tcmVtb3ZhYmxlIG1lZGlhCglNb2Rl
bCBOdW1iZXI6ICAgICAgIEcuU0tJTEwgMTI4R0IgU1NEICAgICAgICAgICAgICAgICAgICAg
ICAKCVNlcmlhbCBOdW1iZXI6ICAgICAgTUswMTA4NDgwQTU0NTAwM0IgICAKCUZpcm13YXJl
IFJldmlzaW9uOiAgMDIuMTAxMDQKU3RhbmRhcmRzOgoJVXNlZDogQVRBL0FUQVBJLTcgVDEz
IDE1MzJEIHJldmlzaW9uIDRhIAoJU3VwcG9ydGVkOiA4IDcgNiA1ICYgc29tZSBvZiA4CkNv
bmZpZ3VyYXRpb246CglMb2dpY2FsCQltYXgJY3VycmVudAoJY3lsaW5kZXJzCTE2MzgzCTE2
MzgzCgloZWFkcwkJMTYJMTYKCXNlY3RvcnMvdHJhY2sJNjMJNjMKCS0tCglDSFMgY3VycmVu
dCBhZGRyZXNzYWJsZSBzZWN0b3JzOiAgIDE2NTE0MDY0CglMQkEgICAgdXNlciBhZGRyZXNz
YWJsZSBzZWN0b3JzOiAgMjUwNDQ1ODI0CglMb2dpY2FsL1BoeXNpY2FsIFNlY3RvciBzaXpl
OiAgICAgICAgICAgNTEyIGJ5dGVzCglkZXZpY2Ugc2l6ZSB3aXRoIE0gPSAxMDI0KjEwMjQ6
ICAgICAgMTIyMjg4IE1CeXRlcwoJZGV2aWNlIHNpemUgd2l0aCBNID0gMTAwMCoxMDAwOiAg
ICAgIDEyODIyOCBNQnl0ZXMgKDEyOCBHQikKCWNhY2hlL2J1ZmZlciBzaXplICA9IHVua25v
d24KQ2FwYWJpbGl0aWVzOgoJTEJBLCBJT1JEWShjYW4gYmUgZGlzYWJsZWQpCglTdGFuZGJ5
IHRpbWVyIHZhbHVlczogc3BlYydkIGJ5IFN0YW5kYXJkLCBubyBkZXZpY2Ugc3BlY2lmaWMg
bWluaW11bQoJUi9XIG11bHRpcGxlIHNlY3RvciB0cmFuc2ZlcjogTWF4ID0gMQlDdXJyZW50
ID0gPwoJUmVjb21tZW5kZWQgYWNvdXN0aWMgbWFuYWdlbWVudCB2YWx1ZTogMTI4LCBjdXJy
ZW50IHZhbHVlOiAyNTQKCURNQTogbWRtYTAgbWRtYTEgbWRtYTIgdWRtYTAgdWRtYTEgdWRt
YTIgdWRtYTMgdWRtYTQgKnVkbWE1IAoJICAgICBDeWNsZSB0aW1lOiBtaW49MTIwbnMgcmVj
b21tZW5kZWQ9MTIwbnMKCVBJTzogcGlvMCBwaW8xIHBpbzIgcGlvMyBwaW80IAoJICAgICBD
eWNsZSB0aW1lOiBubyBmbG93IGNvbnRyb2w9MTIwbnMgIElPUkRZIGZsb3cgY29udHJvbD0x
MjBucwpDb21tYW5kcy9mZWF0dXJlczoKCUVuYWJsZWQJU3VwcG9ydGVkOgoJICAgKglTTUFS
VCBmZWF0dXJlIHNldAoJICAgKglQb3dlciBNYW5hZ2VtZW50IGZlYXR1cmUgc2V0CgkgICAq
CVdyaXRlIGNhY2hlCgkgICAgCUxvb2stYWhlYWQKCSAgICoJTWFuZGF0b3J5IEZMVVNIX0NB
Q0hFCgkgICAqCUdlbjEgc2lnbmFsaW5nIHNwZWVkICgxLjVHYi9zKQoJICAgKglHZW4yIHNp
Z25hbGluZyBzcGVlZCAoMy4wR2IvcykKCSAgICoJSG9zdC1pbml0aWF0ZWQgaW50ZXJmYWNl
IHBvd2VyIG1hbmFnZW1lbnQKCSAgICoJUGh5IGV2ZW50IGNvdW50ZXJzCkNoZWNrc3VtOiBj
b3JyZWN0Cg==
--------------010201000302000700050800--
