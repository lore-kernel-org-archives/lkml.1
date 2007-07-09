Return-Path: <linux-kernel-owner+w=401wt.eu-S1758810AbXGIEps@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758810AbXGIEps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2007 00:45:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751630AbXGIEpl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Jul 2007 00:45:41 -0400
Received: from smtp110.mail.mud.yahoo.com ([209.191.85.220]:23514 "HELO
	smtp110.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751602AbXGIEpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2007 00:45:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=R7sMQ+SYCJo/d7MrtArNQqv0ZRFgd739/mv/VBznOB5veK04Xkh7T5MmzTeGOLqrNyovy0o40fjlUY8Mt9FQ+T/H4VoQlJku2YeTfHb3nHE9Ur/7QkKzWWbb84wXorDM0hGNIVT/hUf1mOcpKd3SXoa8LYCtWKS2wLNmOHKadzI=  ;
X-YMail-OSG: dEhErGwVM1mNSXgnFr2vil4sddRrHGm4xBJVquCp8B.MtkQMo5h3X1FHaXZHFy68YVOiQ4.rhw--
Message-ID: <4691BD6F.8000809@yahoo.com.au>
Date: Mon, 09 Jul 2007 14:45:35 +1000
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: Jeremy Maitin-Shepard <jbms@cmu.edu>
CC: Al Boldi <a1426z@gawab.com>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Hibernation Redesign
References: <200707081737.21932.a1426z@gawab.com> <87tzsew712.fsf@jbms.ath.cx>	<4691B9A5.6060203@yahoo.com.au> <87k5taw5vc.fsf@jbms.ath.cx>
In-Reply-To: <87k5taw5vc.fsf@jbms.ath.cx>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Maitin-Shepard wrote:
> Nick Piggin <nickpiggin@yahoo.com.au> writes:

>>This is the Morton method, isn't it? :) I remember it sounding like a
>>very good idea when he brought it up, but I can't remember the details
>>of why it was rejected or what the problems were.
> 
> 
> Perhaps he did bring it up before I did.  Please forward me a link to
> the thread or other reference if you can find it, as I'd be interested
> in reading it.

Sent in the next mail.


>>I suspect that freeing memory on the fly for the new kernel
>>would be non-trivial (but possible), however simply having a reserve
>>RAM region for the new kernel would be fine for a first step.
> 
> 
> Freeing memory on the fly should be extremely easy for the kernel (this
> is precisely what it does when it needs to satisfy an allocation).  Note
> that the memory allocated need not be contiguous.

Yes, I have a rough idea about how page reclaim works. But I just
mean it would not be trivial to load the new kernel into physically
discontiguous memory. Possible of course, but I don't think kexec or
the setup code could quite cope ATM.

-- 
SUSE Labs, Novell Inc.
