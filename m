Return-Path: <linux-kernel-owner+w=401wt.eu-S933987AbZJNUcx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933987AbZJNUcx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 16:32:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933724AbZJNUcx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 16:32:53 -0400
Received: from cpsmtpm-eml105.kpnxchange.com ([195.121.3.9]:58196 "EHLO
	CPSMTPM-EML105.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933354AbZJNUcw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 16:32:52 -0400
From: Frans Pop <elendil@planet.nl>
To: Massimo Cetra <mcetra@navynet.it>
Subject: Re: Bug on barriers for virtio_blk device - end_request: I/O error, dev vda, sector 0
Date: Wed, 14 Oct 2009 22:32:12 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org, Mark McLoughlin <markmc@redhat.com>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Mikulas Patocka <mpatocka@redhat.com>,
       Alasdair G Kergon <agk@redhat.com>, Neil Brown <neilb@suse.de>,
       virtualization <virtualization@lists.linux-foundation.org>,
       dm-devel <dm-devel@redhat.com>
References: <4AD5DC1D.9070002@navynet.it> <4AD5DC1D.9070002@navynet.it>=?utf-8?q?=0A1_2?= <4AD62690.9080408@navynet.it>
In-reply-To: <4AD62690.9080408@navynet.it>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200910142232.14837.elendil@planet.nl>
X-OriginalArrivalTime: 14 Oct 2009 20:32:15.0135 (UTC) FILETIME=[6A920AF0:01CA4D0D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added CCs for the author of and people CCed on the patch.

The patch has been submitted twice (6 Aug, 3 Sept), the first time there 
was one concern voiced which seems to have been addressed in replies. The 
second time there were no reactions.

The patch seems to work for Massimo...

Massimo Cetra wrote:
> Massimo Cetra ha scritto:
>> Hello all,
>>
>> i ended up with some thiusands of errors after upgrading to 2.6.31.2
>> like this one:
>>
>> end_request: I/O error, dev vda, sector 0
>> end_request: I/O error, dev vda, sector 0
>> end_request: I/O error, dev vda, sector 0
>> end_request: I/O error, dev vda, sector 0
>>
>> I am using ocfs2 on top of drbd on top of LVM in a KVM guest that uses
>> virtio_blk.
>>
>> The bug is already known, see here:
>> https://bugzilla.redhat.com/show_bug.cgi?id=514901
>>
>> A patch exists and the problem has already been submitted here in the
>> list.
>> See here: http://lkml.org/lkml/2009/8/6/153
>>
>> That fix is not in 2.6.31 nor in 2.6.32-RCX
>>
>> Could you please consider pulling it and adding this fix for inclusion
>> in 2.6.31.$next and also to mainline?
>>
>> Thanks.
>
> No one listening here ?

It helps if you CC the people who maintain the relevant code.

> This makes virtio_blk on LVM unusable.

Cheers,
FJP
