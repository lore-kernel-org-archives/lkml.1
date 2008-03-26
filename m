Return-Path: <linux-kernel-owner+w=401wt.eu-S1758005AbYCZNh0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758005AbYCZNh0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2008 09:37:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753935AbYCZNhO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 26 Mar 2008 09:37:14 -0400
Received: from astoria.ccjclearline.com ([64.235.106.9]:55122 "EHLO
	astoria.ccjclearline.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752426AbYCZNhM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2008 09:37:12 -0400
Date: Wed, 26 Mar 2008 09:37:09 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@crashcourse.ca>
X-X-Sender: rpjday@localhost.localdomain
To: David Woodhouse <dwmw2@infradead.org>
cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: why so many unexported headers checking __KERNEL__?
In-Reply-To: <1206537586.9540.280.camel@pmac.infradead.org>
Message-ID: <alpine.LFD.1.00.0803260935460.7900@localhost.localdomain>
References: <alpine.LFD.1.00.0803230229530.1203@localhost.localdomain>  <1206533324.9540.268.camel@pmac.infradead.org>  <alpine.LFD.1.00.0803260846390.6148@localhost.localdomain>  <1206537022.9540.274.camel@pmac.infradead.org> 
 <alpine.LFD.1.00.0803260913350.6316@localhost.localdomain> <1206537586.9540.280.camel@pmac.infradead.org>
User-Agent: Alpine 1.00 (LFD 882 2007-12-20)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-69639996-1206538631=:7900"
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - astoria.ccjclearline.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - crashcourse.ca
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-69639996-1206538631=:7900
Content-Type: TEXT/PLAIN; charset=US-ASCII


On Wed, 26 Mar 2008, David Woodhouse wrote:

> On Wed, 2008-03-26 at 09:16 -0400, Robert P. J. Day wrote:
> > well, since i already have the output from my script, i might toss
> > together some per-directory patches to start removing some of that.
> > this sounds more like a one-shot thing than adding permanent checking
> > to the build process.
>
> Makes sense.
>
> Remember, one of our goals is to move towards having files which are
> just _copied_ (header-y) instead of having these ifdefs. If, in your
> travels, you see a way you can split headers up more sensibly to
> achieve that, it would be good.

just in case anyone was curious, i've attached my Kbuild checking
script.  i'm guessing it's pretty self-explanatory -- you can get an
idea of the condition of the header files at the moment.

rday
--

========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry:
    Have classroom, will lecture.

http://crashcourse.ca                          Waterloo, Ontario, CANADA
========================================================================
--8323328-69639996-1206538631=:7900
Content-Type: APPLICATION/x-sh; name=check_kbuild.sh
Content-Transfer-Encoding: BASE64
Content-ID: <alpine.LFD.1.00.0803260937090.7900@localhost.localdomain>
Content-Description: 
Content-Disposition: attachment; filename=check_kbuild.sh

IyEvYmluL3NoCiMKIwljaGVja19rYnVpbGQuc2gKIwojICBSdW4gdGhpcyBz
Y3JpcHQgZnJvbSB0aGUgdG9wIG9mIHRoZSBzb3VyY2UgdHJlZSwgYW5kIHBh
c3MgaXQKIyB0aGUgS2J1aWxkIGZpbGUgdG8gcHJvY2VzcywgYXMgaW46CiMK
IwkkIGNoZWNrX2tidWlsZC5zaCBpbmNsdWRlL2xpbnV4L0tidWlsZAojCgoj
CiMgIFNvbWUgY29udmVuaWVudCBzZXQgb3BlcmF0b3JzLCBzaW5jZSB0aGlz
IGlzIHRoZSBraW5kIG9mCiMgcHJvYmxlbSB0aGF0IGp1c3QgKnNjcmVhbXMq
IGZvciBzZXQgbWFuaXB1bGF0aW9uLgojCgpmdW5jdGlvbiBzZXRfdW5pb24K
ewoJZWNobyAtZSAiJHsxfVxuJHsyfSIgfCBzb3J0IC11Cn0KCmZ1bmN0aW9u
IHNldF9pbnRuCnsKCWVjaG8gLWUgIiR7MX1cbiR7Mn0iIHwgc29ydCB8IHVu
aXEgLWQKfQoKZnVuY3Rpb24gc2V0X3N1Ygp7Cglsb2NhbCBpbnRuPSQoc2V0
X2ludG4gIiR7MX0iICIkezJ9IikKCWVjaG8gLWUgIiQxXG4ke2ludG59IiB8
IHNvcnQgfCB1bmlxIC11Cn0KCktGSUxFPSQxCmVjaG8gIiR7S0ZJTEV9IgpE
SVI9JChkaXJuYW1lICR7S0ZJTEV9KQoKKGNkICR7RElSfSAmJiB7CgpIRFJT
PSQoZ3JlcCAiXmhlYWRlci15IiBLYnVpbGQgfCBjdXQgLWQnICcgLWYzKQpV
TklTPSQoZ3JlcCAiXnVuaWZkZWYteSIgS2J1aWxkIHwgY3V0IC1kJyAnIC1m
MykKQUxMSD0kKGxzICouaCkKQUxMRVhQPSQoc2V0X3VuaW9uICIke0hEUlN9
IiAiJHtVTklTfSIpCk5PVEVYUD0kKHNldF9zdWIgIiR7QUxMSH0iICIke0FM
TEVYUH0iKQoKIyBlY2hvICJIRFJTID0gJHtIRFJTfSIKIyBlY2hvICJVTklT
ID0gJHtVTklTfSIKIyBlY2hvICJBTExIID0gJHtBTExIfSIKIyBlY2hvICJB
TExFWFAgPSAke0FMTEVYUH0iCiMgZWNobyAiTk9URVhQID0gJHtOT1RFWFB9
IgoKIyAgU2ltcGx5IHVuY29tbWVudCB0aGUgcGFpciBvZiBsaW5lcyBjb3Jy
ZXNwb25kaW5nIHRvIHRoZSBjaGVjayB5b3UKIyB3YW50IHRvIHJ1bi4KCiMg
ZWNobyAiICAgICBBbnkgZW50cmllcyBpbiBib3RoIGxpc3RzPyIKIyBlY2hv
ICIke0hEUlN9IiAiJHtVTklTfSIgfCBzb3J0IHwgdW5pcSAtYyB8IHNvcnQg
LW5yIHwgZ3JlcCAtdiAiXiAgICAgIDEiCgojIGVjaG8gIiAgICAgaGVhZGVy
LXkgZW50cnkgY2hlY2tpbmcgZm9yIF9fS0VSTkVMX18iCiMgZ3JlcCAiI2lm
LipfX0tFUk5FTF9fIiAke0hEUlN9IC9kZXYvbnVsbAoKIyBlY2hvICIgICAg
IHVuaWZkZWYteSBlbnRyeSBub3QgY2hlY2tpbmcgZm9yIF9fS0VSTkVMX18i
CiMgZ3JlcCAtTCAiI2lmLipfX0tFUk5FTF9fIiAke1VOSVN9IC9kZXYvbnVs
bAoKIyBlY2hvICIgICAgIGNoZWNraW5nIF9fS0VSTkVMX18gd2hlbiBub3Qg
ZXZlbiBiZWluZyBleHBvcnRlZDoiCiMgZ3JlcCAiI2lmLipfX0tFUk5FTF9f
IiAke05PVEVYUH0gL2Rldi9udWxsCn0KKQo=

--8323328-69639996-1206538631=:7900--
