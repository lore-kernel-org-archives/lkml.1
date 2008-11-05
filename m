Return-Path: <linux-kernel-owner+w=401wt.eu-S1756675AbYKEN5c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756675AbYKEN5c (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2008 08:57:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755465AbYKEN5G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Nov 2008 08:57:06 -0500
Received: from qb-out-0506.google.com ([72.14.204.226]:5671 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755185AbYKEN5E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2008 08:57:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding
         :sender;
        b=eY4B1NaIP2BRyGJTMTe7o9YLXaehb8PFRD0eg/q6eDS8tciOlg5gzC1d9MyILoBx91
         OIaICO6QsUkF21BJvTeNZ6sMskTv1Ybd9Ei7PuGVa3Eu1TEiSKLdFnv1PqqXT1PVdo8Z
         4QFESa9TgKAs/sffXb4OHYzKmw861+4eOPq8M=
Message-ID: <4911A628.6000504@panasas.com>
Date: Wed, 05 Nov 2008 15:56:56 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: James.Bottomley@HansenPartnership.com, michaelc@cs.wisc.edu,
       fujita.tomonori@lab.ntt.co.jp, jeff@garzik.org, osd-dev@open-osd.org,
       linux-scsi@vger.kernel.org, Sami.Iren@seagate.com, pw@padd.com,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org
Subject: Re: [PATCHSET 00/18] open-osd: OSD Initiator library for Linux
References: <48876009.8010701@panasas.com>	<491073BB.4000900@panasas.com> <20081104111923.bb19c238.akpm@linux-foundation.org>
In-Reply-To: <20081104111923.bb19c238.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:
> On Tue, 04 Nov 2008 18:09:31 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> Please consider for inclusion, an in-kernel OSD initiator
>> library. Its main users are planned to be various OSD based file
>> systems and the pNFS-Objects Layout Driver. (To be submitted soon)
>>  
>> To try out and run the library please visit
>> http://open-osd.org and follow the instructions there.
>>
>> The submitted patchset is also available via git at:
>>    git://git.open-osd.org/linux-open-osd.git osd
>>    http://git.open-osd.org/gitweb.cgi?p=linux-open-osd.git;a=shortlog;h=osd
>>
>> Or a compact out-of-tree repository that includes sources 
>> and some extras:
>>    git://git.open-osd.org/open-osd.git master
>>    http://git.open-osd.org/gitweb.cgi?p=open-osd.git;a=summary
>>
>> ...
>>
>> We would like this to sit in -mm tree for a while to make sure it is compilable
>> on all platform.
> 
> The best way to do that is to include your git tree in linux-next.  If
> this code has a probably-will-be-merged-in-2.6.29 status then please
> prepare a branch for Stephen to include in the linux-next lineup.
> 

Thanks Andrew
I was thinking this code would eventually go into Linux-next threw
James tree. But thought if there was a way for some exposure, so to
give James some confidence in the code before he commits to it. But
this way it could be perfect, thanks.

Stephen Hi
I have just that branch ready it is:
git://git.open-osd.org/linux-open-osd.git osd
Note the "osd" branch. Do I need to call it something special like
"linux-next"? (Give me 24 hours to fix all current comments)

Also one more question. This tree is based on latest scsi-misc-2.6.git,
Because it is destined to go threw James tree at the end. Do I need
to prepare a special tree based on Linus-latest?

Thanks in advance
Boaz
