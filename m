Return-Path: <linux-kernel-owner+w=401wt.eu-S1754655AbZBCQhf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754655AbZBCQhf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Feb 2009 11:37:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752081AbZBCQh1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Feb 2009 11:37:27 -0500
Received: from rv-out-0506.google.com ([209.85.198.233]:34979 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751941AbZBCQh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Feb 2009 11:37:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=IL1x2B0o1lwchWzSK/C6X+dV4ARv2q7lccXxZrBIMRqiAlsNWsg2R6JokjgX0ZlPLd
         bLv2cCp9zeFUwsTWdqWVEc9yS7t2LUtxBydgheZH8dKhZvFvGZMSCw5IiVwSZZV7jjPS
         ibjnq0obDKAZCraLFC614hXxrvKcFn631zw1Q=
MIME-Version: 1.0
Date: Tue, 3 Feb 2009 22:07:25 +0530
Message-ID: <a80c86b70902030837h334268b1r34cf06bf617645fe@mail.gmail.com>
Subject: shrinking root partition and using free space to create a block 
	device
From: Prateek Donni <prateek.donni@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are intending to protect a set of user specified files using LVM
mirroring where the protected space on which the user files are stored
is mirrored on an LV on a different disk. Our problem is that for a
user with a custom layout has installed linux with 2 partitons for
swap and / and there is no other space available on the primary disk
where we can store the files to be protected tht is mirrored across
other disk, so we intend to allocate some space on the primary disk
that can be used as a LV that is mirrored across an LV on different
disk.
What can be done in this situation?
For now we thought of the following:
1> Shrinking the root partition to get some unallocated space that can
be used to create a PV.
	problems :
		a. How do u do it? Can gparted be used online without the live CD?
		b. How much can the root be compressed without the OS failure?
2> Can the root partition be converted into a LV?
3> There is free space on the root partition. Now can we use this free
space to create a block device that can be converted into PV that
would contain my protected files mirrored across other LV on a
different disk. If so how can we do it?
Can anyone help me with this?
Thanks a lot.
