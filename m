Return-Path: <linux-kernel-owner+w=401wt.eu-S1761271AbXEJNja@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761271AbXEJNja (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 09:39:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758185AbXEJNjJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 09:39:09 -0400
Received: from rgminet01.oracle.com ([148.87.113.118]:32880 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752097AbXEJNjI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 09:39:08 -0400
Message-ID: <46431FEC.7000901@oracle.com>
Date: Thu, 10 May 2007 09:36:44 -0400
From: Chuck Lever <chuck.lever@oracle.com>
Reply-To: chuck.lever@oracle.com
Organization: Oracle Corporation
User-Agent: Thunderbird 2.0.0.0 (X11/20070326)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Trond Myklebust <Trond.Myklebust@netapp.com>,
       Jeff Garzik <jeff@garzik.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       NeilBrown <neilb@suse.de>, Adrian Bunk <bunk@stusta.de>
Subject: Re: [bisect] NFS regression breaks X
References: <46423D62.2070200@garzik.org>	 <1178748206.6760.3.camel@heimdal.trondhjem.org>	 <20070509155228.d1b9d644.akpm@linux-foundation.org> <1178755813.6760.26.camel@heimdal.trondhjem.org>
In-Reply-To: <1178755813.6760.26.camel@heimdal.trondhjem.org>
Content-Type: multipart/mixed;
 boundary="------------050203050704090904090506"
X-Whitelist: TRUE
X-Whitelist: TRUE
X-Brightmail-Tracker: AAAAAQAAAAI=
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------050203050704090904090506
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Trond Myklebust wrote:
> On Wed, 2007-05-09 at 15:52 -0700, Andrew Morton wrote:
>> It's a bit rough that Jeff spent a large amount of time hunting down an
>> already-known bug.  That's normally my job :(
> 
> The bug was reported by Florin Iucha (on lkml!) on Saturday. It has only
> just been debugged, and I was in fact in the middle of marshalling the
> fixes.
> 
>> This five-week-old diff only ever appeared in 2.6.21-mm1, which was
>> released four days ago.  It was then whizzed into mainline.  We thus lost
>> five weeks public testing which would probably have saved Jeff his pain.
>>
>> What went wrong?
> 
> Probably my fault. I've had a couple of weeks of heavy travel due to
> various circumstances that were beyond my control, and so I had little
> time in which to test the stuff and push it out.
> 
> Another factor that is affecting us is the slow but gradual collapse of
> the OSDL NFSv4 regression testing effort.

I had expected that many of these issues would be caught by the OSDL 
test harness.  I learned only yesterday that it was no longer available, 
so I am making an effort to broaden my personal test regime.

--------------050203050704090904090506
Content-Type: text/x-vcard; charset=utf-8;
 name="chuck.lever.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="chuck.lever.vcf"

begin:vcard
fn:Chuck Lever
n:Lever;Chuck
org:Oracle Corporation;Corporate Architecture: Linux Projects Group
adr:;;1015 Granger Avenue;Ann Arbor;MI;48104;USA
title:Principal Member of Staff
tel;work:+1 248 614 5091
x-mozilla-html:FALSE
url:http://oss.oracle.com/~cel/
version:2.1
end:vcard


--------------050203050704090904090506--
