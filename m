Return-Path: <linux-kernel-owner+w=401wt.eu-S1757510AbXISKCd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510AbXISKCd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2007 06:02:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755309AbXISKCY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Sep 2007 06:02:24 -0400
Received: from smtp105.mail.mud.yahoo.com ([209.191.85.215]:48163 "HELO
	smtp105.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754140AbXISKCW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2007 06:02:22 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=adTki38/6mBwPU7KLiHPtObLCm8twap7jZ3lDfxrw5BuhbCBP6XB+Z5ESF13XKiZ6tAJqdeOOSLx4QIPaO+8xy2gkgR8xqs5i/zp2WJmMODGSFwstjZ4w1pqhDKCyCvaRQ0/0WCEWSmNYz4j7SbSm+YzjOdHq/g3V83k3xTGvjE=  ;
X-YMail-OSG: 4uWmME0VM1mqnl3iasBe7zOrfvljkBAqUW5zqFE0sMzV0CZh8.AP2oNjEFfM6WUPbf0n6J2mQA--
From: Nick Piggin <nickpiggin@yahoo.com.au>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [00/41] Large Blocksize Support V7 (adds memmap support)
Date: Wed, 19 Sep 2007 03:53:48 +1000
User-Agent: KMail/1.9.5
Cc: Christoph Lameter <clameter@sgi.com>, Mel Gorman <mel@skynet.ie>,
       andrea@suse.de, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
       William Lee Irwin III <wli@holomorphy.com>, David Chinner <dgc@sgi.com>,
       Jens Axboe <jens.axboe@oracle.com>,
       Badari Pulavarty <pbadari@gmail.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Fengguang Wu <fengguang.wu@gmail.com>, swin wang <wangswin@gmail.com>,
       totty.lu@gmail.com, hugh@veritas.com, joern@lazybastard.org
References: <20070911060349.993975297@sgi.com> <200709181116.22573.nickpiggin@yahoo.com.au> <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.999.0709181126330.16478@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200709190353.49570.nickpiggin@yahoo.com.au>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 19 September 2007 04:30, Linus Torvalds wrote:
> On Tue, 18 Sep 2007, Nick Piggin wrote:
> > ROFL! Yeah of course, how could I have forgotten about our trusty OOM
> > killer as the solution to the fragmentation problem? It would only have
> > been funnier if you had said to reboot every so often when memory gets
> > fragmented :)
>
> Can we please stop this *idiotic* thread.
>
> Nick, you and some others seem to be arguing based on a totally flawed
> base, namely:
>  - we can guarantee anything at all in the VM
>  - we even care about the 16kB blocksize
>  - second-class citizenry is "bad"
>
> The fact is, *none* of those things are true. The VM doesn't guarantee
> anything, and is already very much about statistics in many places. You
> seem to be arguing as if Christoph was introducing something new and
> unacceptable, when it's largely just more of the same.

I will stop this idiotic thread.

However, at the VM and/or vm/fs things we had, I was happy enough
for this thing of Christoph's to get merged. Actually I even didn't care
if it had mmap support, so long as it solved their problem.

But a solution to the general problem of VM and IO scalability, it is not.
IMO.


> And the fact is, nobody but SGI customers would ever want the 16kB
> blocksize. IOW - NONE OF THIS MATTERS!

Maybe. Maybe not.


> Can you guys stop this inane thread already, or at least take it private
> between you guys, instead of forcing everybody else to listen in on your
> flamefest.

Will do. Sorry.
