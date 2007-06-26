Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbXFZDUj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbXFZDUj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 23:20:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752515AbXFZDU3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 23:20:29 -0400
Received: from server.rillion.net ([207.210.78.215]:38990 "EHLO rillion.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752293AbXFZDU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 23:20:29 -0400
Message-ID: <468085E9.70804@rillion.net>
Date: Tue, 26 Jun 2007 15:20:09 +1200
From: Graeme Sheppard <nodes@rillion.net>
User-Agent: Thunderbird 2.0.0.4 (X11/20070616)
MIME-Version: 1.0
To: Neil Brown <neilb@suse.de>
CC: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: Patent or not patent a new idea
References: <46803772.7020408@rillion.net>	<46806CCB.6020708@rillion.net> <18048.30679.872740.744997@notabene.brown>
In-Reply-To: <18048.30679.872740.744997@notabene.brown>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Neil Brown wrote:
> On Tuesday June 26, nodes@rillion.net wrote:
>> Posting it here seems the best thing to do.
>> 
>> To the inventor goes naming privilege and I'm calling this one softer raid.
>> It is a form of storage raid implemented in software, as contrasted to
>> software and hardware raid which are dependent on using required hardware.
>> 
>> To create a loop filesystem is straight forward. The commands are dd,
>> mkfs.*, mount -o loop. Basically what I propose is that the image file is
>> copied to another harddisk (in the case of ide not on the same cable) and
>> it too is mounted in conjunction of the original with cooperation. When a
>> read request for a block of say 100k is made, the kernel pulls 50k from
>> each disk - maybe a simple doubling of throughput.
> 
> Sounds a lot like "RAIF" - ask google for details.

I did not know about RAIF. RAIF "merges" separate filesystems? That is a
good idea in itself.

My idea is for driver that provides a filesystem from image files it
controls. Because it knows these resources it uses access in tandem to
attain performance.

