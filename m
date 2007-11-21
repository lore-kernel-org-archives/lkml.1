Return-Path: <linux-kernel-owner+w=401wt.eu-S1760978AbXKUO7v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760978AbXKUO7v (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2007 09:59:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751977AbXKUO7l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Nov 2007 09:59:41 -0500
Received: from anchor-post-34.mail.demon.net ([194.217.242.92]:3801 "EHLO
	anchor-post-34.mail.demon.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750958AbXKUO7l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2007 09:59:41 -0500
Message-ID: <47444807.9050803@lougher.demon.co.uk>
Date: Wed, 21 Nov 2007 15:00:23 +0000
From: Phillip Lougher <phillip@lougher.demon.co.uk>
User-Agent: Thunderbird 2.0.0.4 (X11/20070618)
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: Dave Jones <davej@redhat.com>, maximilian attems <max@stro.at>,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [ANN] Squashfs 3.3 released
References: <472EFACA.1090308@lougher.demon.co.uk> <20071105115624.GJ14432@baikonur.stro.at> <4731E880.6010303@lougher.demon.co.uk> <20071120235048.GA15764@redhat.com> <47443A83.2020607@lougher.demon.co.uk> <20071121144835.GA7556@infradead.org>
In-Reply-To: <20071121144835.GA7556@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Christoph Hellwig wrote:
> On Wed, Nov 21, 2007 at 02:02:43PM +0000, Phillip Lougher wrote:
>> Unfortunately the move to fixed little endian filesystem will involve 
>> another filesystem layout change.  The current filesystem layout still 
>> uses packed bitfield structures, and it is impossible to swap these 
>> using the standard kernel swap macros.  Removal of my routines that can 
>> properly swap packed bitfield structures is another change demanded by 
>> the Linux kernel mailing list.
> 
> The normal way to do it is to use shift and mask after doing the endian
> conversion.  But the problem with bitfields is that they can have different
> kinds of layouts depending on the compiler or abi which is another reason
> to avoid them in ondisk/wire formats.
> 

Yes, the bitfields are packed differently on little and big endian 
architectures which mean they appear in different places in the 
structure. I want to move away from that mess when I move to little 
endian only.

Phillip

