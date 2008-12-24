Return-Path: <linux-kernel-owner+w=401wt.eu-S1752479AbYLXLiY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479AbYLXLiY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Dec 2008 06:38:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751621AbYLXLiQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Dec 2008 06:38:16 -0500
Received: from utl-lnx3.nwu.ac.za ([143.160.36.166]:59568 "EHLO
	utl-lnx3.nwu.ac.za" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751214AbYLXLiP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Dec 2008 06:38:15 -0500
Message-Id: <49523B37.3D93.006F.0@nwu.ac.za>
X-Mailer: Novell GroupWise Internet Agent 7.0.2 HP
Date: Wed, 24 Dec 2008 13:37:59 +0200
From: "Martin Schlemmer" <Martin.Schlemmer@nwu.ac.za>
To: "Willy Tarreau" <w@1wt.eu>,
       "Martin Schlemmer" <Martin.Schlemmer@nwu.ac.za>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: Initramfs from existing vmlinuz
References: <49518245.3D93.006F.0@nwu.ac.za> <20081223233410.GC6800@1wt.eu>
In-Reply-To: <20081223233410.GC6800@1wt.eu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 2008/12/24 at 01:34 AM, Willy Tarreau <w@1wt.eu> wrote:
> On Wed, Dec 24, 2008 at 12:28:53AM +0200, Martin Schlemmer wrote:

Hi Willy

>> I had a bit of an accident, and wondered if somebody already had to try to 
> extract the initramfs image from an existing vmlinuz?
>> 
>>  I did try google, but either my search terms was not right, or nobody 
> really touched on the subject before, because all the results mostly dealt 
> with an external image.
>> 
>> Any advice will be appreciated.
> 
> yes, it happens to me from time to time.
> You first have to extract and uncompress the ELF image from vmlinuz. For
> this, look for the gzip signature 1F 8B 08 in your vmlinuz, and feed all
> data starting from this point to zcat. Either you do the same on the
> resulting file -and you may find several compressed images- or you simply
> pass it through "objdump -h". It will show you a .init.ramfs section. Use
> the fourth field as the file offset, and dump from that position. You'll
> find your initramfs, likely starting with 1F 8B 08 since it's supposed
> to be compressed with gzip.
> 
> You need an hex editor, dd, zcat and objdump for this. It's not much
> complicated once you have the tools, but it might require a few attempts
> before finding the right image (I tend to find config.gz before initramfs).
> 

Appreciated, I should be able to go from here now - just getting the starting point is sometimes the main issue.


Thanks

M


