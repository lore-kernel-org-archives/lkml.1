Return-Path: <linux-kernel-owner+w=401wt.eu-S1753380AbXHZPlO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753380AbXHZPlO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Aug 2007 11:41:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbXHZPk7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 26 Aug 2007 11:40:59 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:10710 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751667AbXHZPk6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Aug 2007 11:40:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=efSzOeUrotxwyU4wlZWk/98pBZf5Li2DQaUxV0Fprcbhd7H+oRRgTVJgegr88kN6ObfzHdd3j+q38pDqSmxj1RY7qZWGNj+R6rvQ1e0FrctNWBZ+QuwzjyWq3uav1VCzmwaDMV+OCwkdlBb5V8ZoQt1HoP6BriZEib7AByojxfo=
Message-ID: <466ad3f90708260840u2428ad90rac4bc04b5f429bdc@mail.gmail.com>
Date: Sun, 26 Aug 2007 11:40:57 -0400
From: "Fred Tyler" <fredty8@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: Slow, persistent memory leak in 2.6.20
In-Reply-To: <466ad3f90708260739v645294b9t641cb8258dcc4f4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <466ad3f90708260739v645294b9t641cb8258dcc4f4@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/26/07, Fred Tyler <fredty8@gmail.com> wrote:
> I think I've come across a memory leak in 2.6.20. I've upgraded to the
> latest 2.6.20.17, but it didn't seem to help.

One more thing, I just found this message from July from someone
seeing a similar problem:

    http://lkml.org/lkml/2007/7/27/305

I am also running reiserfs, so I wonder if that has something to do
with this. Unlike the other poster, though, I am running an unmodified
kernel and have not seen the error he saw in the system logs.

Here's my output from /proc/meminfo in case it helps:

$ cat /proc/meminfo
MemTotal:      4053564 kB
MemFree:        144344 kB
Buffers:        310824 kB
Cached:        2684244 kB
SwapCached:         64 kB
Active:        1858644 kB
Inactive:      1510808 kB
SwapTotal:       65528 kB
SwapFree:        65316 kB
Dirty:            1772 kB
Writeback:           0 kB
AnonPages:      363844 kB
Mapped:          46924 kB
Slab:           509276 kB
SReclaimable:   467220 kB
SUnreclaim:      42056 kB
PageTables:       9660 kB
NFS_Unstable:        0 kB
Bounce:              0 kB
CommitLimit:   2092308 kB
Committed_AS:   854520 kB
VmallocTotal: 34359738367 kB
VmallocUsed:      4936 kB
VmallocChunk: 34359733423 kB
