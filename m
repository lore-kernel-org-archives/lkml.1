Return-Path: <linux-kernel-owner+w=401wt.eu-S1756900AbZBRTYl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900AbZBRTYl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Feb 2009 14:24:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753545AbZBRTYc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Feb 2009 14:24:32 -0500
Received: from mail.tpi.com ([70.99.223.143]:1640 "EHLO mail.tpi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750740AbZBRTYc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Feb 2009 14:24:32 -0500
Message-ID: <499C6064.7050502@canonical.com>
Date: Wed, 18 Feb 2009 12:24:20 -0700
From: Tim Gardner <tim.gardner@canonical.com>
Reply-To: tim.gardner@canonical.com
User-Agent: Thunderbird 2.0.0.19 (X11/20090105)
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: tytso@mit.edu,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Ubuntu Jaunty ext3 --> ext4 upgrade issue
References: <499C4F1E.8050901@canonical.com> <1234984717.4785.0.camel@laptop>
In-Reply-To: <1234984717.4785.0.camel@laptop>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Wed, 2009-02-18 at 11:10 -0700, Tim Gardner wrote:
>> Ted,
>>
>> I've encountered a situation where the patches that you've proposed for
>> stable updates might be causing some issues. This user ivoks appears to
>> have an upgrade issue. I assume he's enabled ext4 on an existing ext3
>> file system. Hopefully I can get more details. Have you seen anything
>> like this?
>>
>> After looking at your for-stable branch, I think I'm missing a couple of
>> jbd2 patches. Could they be significant?
>>
>> rtg
>>
>> <ivoks> i'm getting 'Invalid or unsupported executable format' from grub
>> on all jaunty's generic kernels since (including) 2.6.28-7
> 
> Does your grub have ext4 support? Otherwise I would suggest not
> converting /boot (or whatever other partition is used to load the kernel
> from).
> 

Yep - Colin King implemented support for ext4 in grub 0.97.

rtg
-- 
Tim Gardner tim.gardner@canonical.com
