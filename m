Return-Path: <linux-kernel-owner+w=401wt.eu-S1758107AbZEZWDl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758107AbZEZWDl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 May 2009 18:03:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753712AbZEZWDc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 May 2009 18:03:32 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:61743 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751857AbZEZWDb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 May 2009 18:03:31 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.0905261756390.11998-100000@iolanthe.rowland.org>
References: <ac3eb2510905261413r54e5bb18n7faf888aa55d8830@mail.gmail.com> 
	<Pine.LNX.4.44L0.0905261756390.11998-100000@iolanthe.rowland.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 27 May 2009 00:03:11 +0200
Message-ID: <ac3eb2510905261503k32db6197m84d1e78858e53da1@mail.gmail.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs 
	directories.
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>,
       SCSI development list <linux-scsi@vger.kernel.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 26, 2009 at 23:56, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Tue, 26 May 2009, Kay Sievers wrote:
>
>> Ok, I copied my newly installed system to another disks, to have a
>> root filesytem to trash again by this bug. :)
>>
>> Which of your patches should I try?
>
> James's patch, not mine.

I tried both, both don't fix the issue. With Alan's patch it *seems*
the target device never gets removed, at least I didn't see anything
in the kobject debug logs.

Kay
