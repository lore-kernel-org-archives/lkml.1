Return-Path: <linux-kernel-owner+w=401wt.eu-S1754583AbYAHVm1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583AbYAHVm1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 16:42:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752549AbYAHVmT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 16:42:19 -0500
Received: from 216-99-213-120.dsl.aracnet.com ([216.99.213.120]:57677 "EHLO
	clueserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751886AbYAHVmS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 16:42:18 -0500
X-Greylist: delayed 622 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Jan 2008 16:42:17 EST
Message-ID: <60808.198.182.194.170.1199827911.squirrel@clueserver.org>
In-Reply-To: <200801090022.55589.a1426z@gawab.com>
References: <200801090022.55589.a1426z@gawab.com>
Date: Tue, 8 Jan 2008 13:31:51 -0800 (PST)
Subject: Re: [RFD] Incremental fsck
From: "Alan" <alan@clueserver.org>
To: "Al Boldi" <a1426z@gawab.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
User-Agent: SquirrelMail/1.4.10a-1.fc6
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Andi Kleen wrote:
>> Theodore Tso <tytso@mit.edu> writes:
>> > Now, there are good reasons for doing periodic checks every N mounts
>> > and after M months.  And it has to do with PC class hardware.  (Ted's
>> > aphorism: "PC class hardware is cr*p").
>>
>> If these reasons are good ones (some skepticism here) then the correct
>> way to really handle this would be to do regular background scrubbing
>> during runtime; ideally with metadata checksums so that you can actually
>> detect all corruption.
>>
>> But since fsck is so slow and disks are so big this whole thing
>> is a ticking time bomb now. e.g. it is not uncommon to require tens
>> of minutes or even hours of fsck time and some server that reboots
>> only every few months will eat that when it happens to reboot.
>> This means you get a quite long downtime.
>
> Has there been some thought about an incremental fsck?

Is that anything like a cluster fsck? ]:>
