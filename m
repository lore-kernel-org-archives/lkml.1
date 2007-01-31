Return-Path: <linux-kernel-owner+w=401wt.eu-S932936AbXAaSqA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932936AbXAaSqA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Jan 2007 13:46:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933317AbXAaSqA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Jan 2007 13:46:00 -0500
Received: from tmailer.gwdg.de ([134.76.10.23]:36322 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932936AbXAaSp7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Jan 2007 13:45:59 -0500
Date: Wed, 31 Jan 2007 19:45:02 +0100 (MET)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Helge Hafting <helge.hafting@aitel.hist.no>
cc: Eddie Pettis <pettis.eddie@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: How to locate struct file * from a bio?
In-Reply-To: <45C0B343.1090301@aitel.hist.no>
Message-ID: <Pine.LNX.4.61.0701311943110.13737@yvahk01.tjqt.qr>
References: <d66e87630701310634s385db5adwa82e2194188efa81@mail.gmail.com>
 <45C0B343.1090301@aitel.hist.no>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Jan 31 2007 16:18, Helge Hafting wrote:
> Eddie Pettis wrote:
>> Longer version:  I am working on a project that requires measuring the
>> popularity of each file in a filesystem.  I have made several attempts
>> to locate all the file reads by grepping for ->readpage() and
>> ->readpages() calls, but I am still missing several file reads.  I
>> have not yet looked for file writes.
>
> Why don't you tap into "open" instead?
> Here you can note who opens the file and if they open it for
> reading or writing.  If you really need the amount of data
> transferred, consider trapping the read and write syscalls too.

And to add the sugar on top: in case you can live without tracing / (root
filesystem), you can write your very own fuse filesystem layer in a few
minutes and trace every small thing. Or perhaps take an existing project
(aufs/unionfs) and enhance the module with some the wanted hooks, etc.


Jan
-- 
