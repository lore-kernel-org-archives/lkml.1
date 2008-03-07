Return-Path: <linux-kernel-owner+w=401wt.eu-S1763566AbYCGL45@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763566AbYCGL45 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2008 06:56:57 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759142AbYCGL4s
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Mar 2008 06:56:48 -0500
Received: from moutng.kundenserver.de ([212.227.126.174]:59491 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759117AbYCGL4r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2008 06:56:47 -0500
From: Bodo Eggert <7eggert@gmx.de>
Subject: Re: [PATCH] Modify loop device to be able to manage partitions of the disk image
To: Nick Piggin <nickpiggin@yahoo.com.au>,
       Laurent Vivier <Laurent.Vivier@bull.net>, linux-kernel@vger.kernel.org
Reply-To: 7eggert@gmx.de
Date: Fri, 07 Mar 2008 12:56:39 +0100
References: <a4kTW-44U-25@gated-at.bofh.it> <a4l3D-4hn-11@gated-at.bofh.it> <a4lmN-4Xt-7@gated-at.bofh.it> <a4m9d-6iD-7@gated-at.bofh.it>
User-Agent: KNode/0.10.4
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8Bit
Message-Id: <E1JXbBo-0000ix-57@be1.7eggert.dyndns.org>
X-be10.7eggert.dyndns.org-MailScanner-Information: See www.mailscanner.info for information
X-be10.7eggert.dyndns.org-MailScanner: Found to be clean
X-be10.7eggert.dyndns.org-MailScanner-From: 7eggert@gmx.de
X-Provags-ID: V01U2FsdGVkX1+LbBoDeAqXoIUXlisgm+f0CErJTUQM0bsAe1o
 mNlQzI8YjzGduwbww3Q5SZmJri9QqYk72z7YD0qTDH4KXWeS2b
 ryWhsHq59GIE+6DrthjRQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <nickpiggin@yahoo.com.au> wrote:
> On Thursday 06 March 2008 21:16, Laurent Vivier wrote:
>> Le jeudi 06 mars 2008 à 20:57 +1100, Nick Piggin a écrit :

>> > Do you think we do something similar for drivers/block/brd.c too? I'd
>> > like to try to maintain parity between them where possible...
>>
>> I think it is possible  (I've the same patch for NBD too), but I think
>> it is completely useless.
> 
> It's useful for testing, and for minimising the divergence in the
> code.

Maybe there should be a common mechanism to use partitions on any block
device. Maybe there is - I have dark memories about the device mapper
being able to parse partition tables, and plans on moving partition
support to userspace.

