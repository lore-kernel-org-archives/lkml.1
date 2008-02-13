Return-Path: <linux-kernel-owner+w=401wt.eu-S1764766AbYBMBVV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764766AbYBMBVV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2008 20:21:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754075AbYBMBVH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 Feb 2008 20:21:07 -0500
Received: from smtpq1.tilbu1.nb.home.nl ([213.51.146.200]:46311 "EHLO
	smtpq1.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753513AbYBMBVF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2008 20:21:05 -0500
Message-ID: <47B24663.4070101@keyaccess.nl>
Date: Wed, 13 Feb 2008 02:22:43 +0100
From: Rene Herman <rene.herman@keyaccess.nl>
User-Agent: Thunderbird 2.0.0.9 (X11/20071031)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: David Miller <davem@davemloft.net>, chris.mason@oracle.com,
       linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
       btrfs-devel@oss.oracle.com
Subject: Re: BTRFS partition usage...
References: <Pine.LNX.4.64.0802121518500.21102@fbirervta.pbzchgretzou.qr> <200802120935.20437.chris.mason@oracle.com> <Pine.LNX.4.64.0802121543240.21102@fbirervta.pbzchgretzou.qr> <20080212.153836.166202106.davem@davemloft.net> <Pine.LNX.4.64.0802130040350.14275@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0802130040350.14275@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -1.0 (-)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13-02-08 00:42, Jan Engelhardt wrote:

> x86 MSDOS partition table layout starts counting with sector 1, which is
> (not so intuitively) starting at 0x7e00 (and there's no sector 0, 
> probably for safety). Well, each ptable format with its own quirks.

I haven't followed this thread, but in case it matters -- this sounds fairly 
confused.

Not sure what you're saying, but the MSDOS partition table has its root 
table in the very first sector on the disk, at offset 0x1be = 0x200 - 4 * 
sizeof(struct partition) - 2 (that is, 4 entries at the end of that first 
sector, followed by a 2-byte signature).

That 0x7e00 that you are speaking of sounds somewhat like the _memory_ 
address the BIOS loads that first sector to: 0x7c00. It then jumps there to 
start the ball rolling but 0x7c00 is not an on-disk reality or anything.

MS-DOS partition tables are furthermore fully outside the actual partitions 
themselves and as such I believe not all together relevant to the issue? (as 
said, not following along though...)

Rene
