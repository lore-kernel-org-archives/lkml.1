Return-Path: <linux-kernel-owner+w=401wt.eu-S1757648AbXJNN1o@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648AbXJNN1o (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2007 09:27:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755686AbXJNN1g
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Oct 2007 09:27:36 -0400
Received: from rtr.ca ([76.10.145.34]:2758 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbXJNN1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2007 09:27:35 -0400
Message-ID: <47121943.2030902@rtr.ca>
Date: Sun, 14 Oct 2007 09:27:31 -0400
From: Mark Lord <lkml@rtr.ca>
User-Agent: Thunderbird 2.0.0.6 (X11/20070728)
MIME-Version: 1.0
To: vignesh babu <vigneshbabu@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: wierd file perms
References: <3d1754a30710131010h5d3cbb28tfeb8b4228a448f2e@mail.gmail.com> <20071013172848.GE16774@lug-owl.de>
In-Reply-To: <20071013172848.GE16774@lug-owl.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jan-Benedict Glaw wrote:
> On Sat, 2007-10-13 22:40:23 +0530, vignesh babu <vigneshbabu@gmail.com> wrote:
>> I was surprised and did an ls -l on the files and guess what I found:
>>
>> total 0
>> ?--------- ? ? ? ?                ? fcntl.c
>> ?--------- ? ? ? ?                ? fifo.c
>> ?--------- ? ? ? ?                ? filesystems.c
>> ?--------- ? ? ? ?                ? file_table.c
>> ?--------- ? ? ? ?                ? freevxfs
>>
>> So end result is that, Im not able to delete the files or change perms
>> or ownership even as root.
> 
> Most probably, your filesystem is broken and needs a fsck.

No, this is perfectly normal behaviour, for when a directory
has READ permissions but not EXECUTE permissions.

Eg.

	mkdir a
	touch a/b
	chmod 644 a
	ls -l a

Try it!

Cheers
