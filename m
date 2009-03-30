Return-Path: <linux-kernel-owner+w=401wt.eu-S1755147AbZC3QV5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755147AbZC3QV5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Mar 2009 12:21:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751133AbZC3QVs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 30 Mar 2009 12:21:48 -0400
Received: from rtr.ca ([76.10.145.34]:53286 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931AbZC3QVs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Mar 2009 12:21:48 -0400
Message-ID: <49D0F198.5040606@rtr.ca>
Date: Mon, 30 Mar 2009 12:21:44 -0400
From: Mark Lord <lkml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: Hans Verkuil <hverkuil@xs4all.nl>
Cc: ivtv-devel@ivtvdriver.org, Linux Kernel <linux-kernel@vger.kernel.org>,
       v4l-dvb-maintainer@linuxtv.org, g.liakhovetski@gmx.de,
       video4linux-list@redhat.com
Subject: Re: [ivtv-devel] 2.6.29: ivtv-vbi.c: divide-by-zero in compress_sliced_buf()
References: <49D03596.8030802@rtr.ca> <200903301100.31611.hverkuil@xs4all.nl>
In-Reply-To: <200903301100.31611.hverkuil@xs4all.nl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans Verkuil wrote:
> On Monday 30 March 2009 17:50:33 Mark Lord wrote:
>> Hans Verkuil wrote:
..
>>> Hmm, is v4l2_common also a module? There is a bug there that could
>>> explain it, but only if v4l2_common is compiled into the kernel.
>> ..
>> Ah, yes I don't see that in lsmod, and I do appear to have
>> CONFIG_VIDEO_V4L2_COMMON=y in the .config file.  I'll rebuild as module
>> and try again.  Is there a fix heading upstream (2.6.29.1) for that?
> 
> Ah! That's it then. I definitely need to send a fix for that upstream. It is 
> in the v4l-dvb repository. I need to wait until the fix is merged in Linus' 
> git tree, though, before I can get it in the stable series.
..
> Let me know if building v4l2-common as a module will fix this. I'm positive 
> it will.
..

Works like a charm.  Thanks so much, Hans!

Cheers
