Return-Path: <linux-kernel-owner+w=401wt.eu-S1755954Ab0AMPxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755954Ab0AMPxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 10:53:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755696Ab0AMPx3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 10:53:29 -0500
Received: from one.firstfloor.org ([213.235.205.2]:46361 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab0AMPx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 10:53:26 -0500
Date: Wed, 13 Jan 2010 16:53:23 +0100
From: Andi Kleen <andi@firstfloor.org>
To: William Allen Simpson <william.allen.simpson@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>,
       Linux Kernel Developers <linux-kernel@vger.kernel.org>,
       Linux Kernel Network Developers <netdev@vger.kernel.org>,
       Ilpo =?iso-8859-1?Q?J=E4rvinen?= <ilpo.jarvinen@helsinki.fi>,
       Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH v4] tcp: harmonize tcp_vx_rcv header length assumptions
Message-ID: <20100113155323.GB24818@basil.fritz.box>
References: <4B49D001.4000302@gmail.com> <4B4DA4F4.6060007@gmail.com> <20100113115617.GA24818@basil.fritz.box> <4B4DE887.6030602@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B4DE887.6030602@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 10:36:39AM -0500, William Allen Simpson wrote:
> Andi Kleen wrote:
>> It's difficult to benchmark this code, but did you check that the code 
>> shrinks after applying this patch at least?
>>
> Good question.  Only on a gross scale with ls -l.
>
> Before: 332612
> After:  332384

size is better.

>
> I've just spent an hour Googling and then trying to decipher the make file
> looking for a standard way to generate the -S (.s output), but no joy.
>
> What make command would you suggest to get the interleaved asm?

make path/to/file.lst

(or .S -- you might need uptodate binutils if the lst listing is messed up)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
