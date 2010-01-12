Return-Path: <linux-kernel-owner+w=401wt.eu-S1751221Ab0ALPaX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221Ab0ALPaX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jan 2010 10:30:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751768Ab0ALPaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Jan 2010 10:30:22 -0500
Received: from fg-out-1718.google.com ([72.14.220.159]:18722 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751221Ab0ALPaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jan 2010 10:30:22 -0500
Date: Tue, 12 Jan 2010 23:32:08 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.33 pagemap endless read loop
Message-ID: <20100112153208.GF3925@hack>
References: <20100110020955.GB25323@basil.fritz.box> <20100110063335.GA3005@hack> <20100110123702.GC25323@basil.fritz.box>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100110123702.GC25323@basil.fritz.box>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 10, 2010 at 01:37:02PM +0100, Andi Kleen wrote:
>> Are you sure
>
>I don't know if it's really endless, but it's doing a good emulation
>of it if it's not.
>
>> 
>> On my 32bit machine, it runs for a long time, but finally exits.
>
>That was on 64bit.
>
>proc01 had accumulated several minutes of CPU time when I stopped it.
>
>> From the document of pagemap, it is the mapping of all the virtual pages
>> of a process, on x86-32, it should be 4G/4K = 1024*1024 pages, also
>
>Only the mapped ones surely?
>
>Right now it looks like it dumps all the holes and that obviously
>will never finish on 64bit which has 47bits of address space.
>

Hmm, could you please try:

     time cat /proc/self/pagemap >/dev/null

? Is it much faster than:

     time cat /proc/self/pagemap

?

Thanks!
-- 
Live like a child, think like the god.
 
