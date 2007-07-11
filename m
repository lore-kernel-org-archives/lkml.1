Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbXGKGih@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbXGKGih (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 02:38:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750899AbXGKGib
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 02:38:31 -0400
Received: from host28-104-static.26-213-b.business.telecomitalia.it ([213.26.104.28]:46779
	"EHLO zeus.san-lorenzo.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbXGKGia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 02:38:30 -0400
Message-ID: <46947ADF.4080605@gts.it>
Date: Wed, 11 Jul 2007 08:38:23 +0200
From: Stefano Rivoir <s.rivoir@gts.it>
User-Agent: Thunderbird 2.0.0.4 (Windows/20070604)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.22 released
References: <alpine.LFD.0.999.0707081639370.31544@woody.linux-foundation.org> <4693327E.6000006@gts.it> <alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0707100824170.3412@woody.linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds wrote:
> 
> On Tue, 10 Jul 2007, Stefano Rivoir wrote:
>> 2.6.22 hangs at boot on my box. Here attached a original dmesg from 2.6.21,
>> and a copy of it where it stops on 2.6.22 (I can't attach the original 2.6.22
>> dmesg because it's not logged to disk yet); it actually stops right after
>> 'init' launches.
> 
> Ok, without any oops or hang in any really obvious place, that doesn't 
> really tell anybody anything specific enough to even start trying to debug 
> this, so you'd need to do one of two things:

Hi,

Ok, the guilty bit is gcc: in my box, compiling kernel with gcc 4.2.x 
(which is installed on my debian/sid) turns into a hang (in init, 
seemingly, maybe not even in kernel itself), while gcc-4.1 is allright.

Probably it's something I had to know before... but the light lit when 
gcc crashed when compiling 2.6.22-git1...

Bye.

-- 
Stefano RIVOIR

