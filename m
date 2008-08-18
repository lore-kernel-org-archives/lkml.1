Return-Path: <linux-kernel-owner+w=401wt.eu-S1755642AbYHRVm6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642AbYHRVm6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 17:42:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751631AbYHRVmq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 17:42:46 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:53676 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751380AbYHRVmp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 17:42:45 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Message-ID:Date:From:User-Agent:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type;
	b=UwNAyOfXsKX9XhSEYQrG3r32glNnmrhI1BPhhBatfBlIjhxGvSAvS92Vjwyn9GqAvPfsJNyMJyTSgrp1qO2EwU4xaPcsakACoDb0Iwjsq5LmPG5TlMZnaEgoFhcWHWJA;
Message-ID: <48A9ECD2.8030801@simon.arlott.org.uk>
Date: Mon, 18 Aug 2008 22:42:42 +0100
From: Simon Arlott <simon@fire.lp0.eu>
User-Agent: Thunderbird 2.0.0.16 (X11/20080726)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       akpm <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>
Subject: Re: BUG in free_block (tainted)
References: <48A9E97B.6060601@simon.arlott.org.uk> <84144f020808181437n34f3a339j3392ccccfdfd60f9@mail.gmail.com>
In-Reply-To: <84144f020808181437n34f3a339j3392ccccfdfd60f9@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------080309080006080102050708"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------080309080006080102050708
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 18/08/08 22:37, Pekka Enberg wrote:
> Hi Simon,
> 
> On Tue, Aug 19, 2008 at 12:28 AM, Simon Arlott <simon@fire.lp0.eu> wrote:
>> http://img169.imageshack.us/img169/1170/1005548cp9.jpg
>>
>> 2.6.27-rc3 09873-gb08c7f5
>>
>> (Tainted with fglrx, but X hadn't been run...)
> 
> Looks like SLAB corruption so fglrx could have caused this even if you
> just loaded the module. Do you have CONFIG_DEBUG_SLAB enabled? If not,
> you might want to try to reproduce this with it. Of course,
> reproducing the oops without fglrx would be most helpful. :-)

In that case please disregard this completely. It's not yet happened again.

fglrx completely breaks slab in fantastic ways... I could show you my 
/proc/slabinfo... the start of it is badly corrupted - but only if X 
has been started (attached).

I might try enabling CONFIG_DEBUG_SLAB, perhaps it can detect that bug...

-- 
Simon Arlott

--------------080309080006080102050708
Content-Type: application/x-bzip;
 name="x.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="x.bz2"

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
9yKKewRRT/4u5IpwoSDpdmSw
--------------080309080006080102050708--
