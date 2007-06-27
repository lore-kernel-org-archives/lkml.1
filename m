Return-Path: <linux-kernel-owner+w=401wt.eu-S1761469AbXF0OlB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761469AbXF0OlB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 10:41:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758501AbXF0Oky
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 10:40:54 -0400
Received: from hosting.zipcon.net ([209.221.136.3]:54320 "EHLO
	hosting.zipcon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757694AbXF0Okx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 10:40:53 -0400
X-Greylist: delayed 1548 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jun 2007 10:40:53 EDT
From: Bill Waddington <william.waddington@beezmo.com>
To: linux-kernel@vger.kernel.org
Cc: Al Boldi <a1426z@gawab.com>
Subject: Re: Please release a stable kernel Linux 3.0
Date: Wed, 27 Jun 2007 07:15:00 -0700
Message-ID: <oor483d2nqn6ae728com1v7v56g0ksotov@4ax.com>
References: <fa.ZV8hYZHQHqzfx1dgOFeEVFRogSg@ifi.uio.no>
In-Reply-To: <fa.ZV8hYZHQHqzfx1dgOFeEVFRogSg@ifi.uio.no>
X-Mailer: Forte Agent 3.3/32.846
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - hosting.zipcon.net
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [0 0] / [47 12]
X-AntiAbuse: Sender Address Domain - beezmo.com
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007 13:53:32 UTC, in fa.linux.kernel you wrote:

>Al Viro wrote:
>> On Wed, Jun 27, 2007 at 11:18:36AM +0200, Zolt?n HUBERT wrote:
>> > And as I understand it, this is (was ?) the whole point of
>> > stable/development kernels. "We" can trust a newer stable
>> > kernel to be a drop-in replacement for an older stable
>> > kernel (from the same series), while development kernels
>> > need time to stabilise with the new whizz-bang-pfouit stuff
>> > that you all so nicely add.
>>
>> "Drop-in" in which sense?  That out-of-tree modules keep working?
>> Not really...
>
>Al, be reasonable.  There are many out-of-tree GPL modules that won't be 
>accepted into mainline, never mind those that shouldn't be accepted.  But 
>these modules do have a right to not be obsoleted by constant API changes.
>
>You are effectively inhibiting the development of an out-of-tree GPL module 
>pool, by constantly pulling the rug under that community.
>
>Do you think this is fair?
>
>
>Thanks!

No, thank *you*!  Here I thought I was the only one...

As a low-life out-of-tree maintainer, I would like to plead for at
least a mitigation of the pain of constantly changing kernel/module
APIs.  I realize that an interface freeze is out of the question, but
how about a more formal and regularized way of flagging changes.  The
nasty mess of version checking works (I guess) but it would sure be
nice to have change flags that were actually tied to the changes
themselves.  Consistently.

(And taking my drivers main-line isn't an option.  It would be fine
with me, but there is *zero* chance that my funky code would be
welcomed into the tree.)

Thanks,
Bill (donning asbestos shorts...)
-- 
William D Waddington
william.waddington@beezmo.com
"Even bugs...are unexpected signposts on
the long road of creativity..." - Ken Burtch
