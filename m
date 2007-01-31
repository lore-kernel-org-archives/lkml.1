Return-Path: <linux-kernel-owner+w=401wt.eu-S932111AbXAaBV6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932111AbXAaBV6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Jan 2007 20:21:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932118AbXAaBV6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Jan 2007 20:21:58 -0500
Received: from smtp104.mail.mud.yahoo.com ([209.191.85.214]:29209 "HELO
	smtp104.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932111AbXAaBV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Jan 2007 20:21:57 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com.au;
  h=Received:X-YMail-OSG:Message-ID:Date:From:User-Agent:X-Accept-Language:MIME-Version:To:CC:Subject:References:In-Reply-To:Content-Type:Content-Transfer-Encoding;
  b=VZQ9Ibkx+3gpKMxoaEe+KaEJcqPo3hXH3wu3EPYSZV7fSFNWYrrGcREavZlQ8q/C+NEjByT8EW9XX3X4fOZS0fI7GAhuV5qcKflavnGMLjJZKLFMuYCsB3uazApxN+YB83/QamFtjz2K721Jtuladu9ghsFEsTHMilRFPBV06D0=  ;
X-YMail-OSG: tEEjlBsVM1louiIc_gSnowb.ssqTigPiUC50kst8TE0QcoTt2pNjlQCVhxHeZKzhR8b4CasX30yehWkN_rQuGr_qnIXnsVLoNxxjZaCLlmztc2pJf3cRwZlvaDEIuf6XLok6R.4DkDqlkmQ5GOufFjIIMLrpbpOL.te.YtH9TL.Ilxt_PCD6kjVwHYuc
Message-ID: <45BFEF2A.5070907@yahoo.com.au>
Date: Wed, 31 Jan 2007 12:21:46 +1100
From: Nick Piggin <nickpiggin@yahoo.com.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.7.12) Gecko/20051007 Debian/1.7.12-1
X-Accept-Language: en
MIME-Version: 1.0
To: "Robert P. J. Day" <rpjday@mindspring.com>
CC: Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@osdl.org>, Paul Mackerras <paulus@samba.org>,
       dhowells@redhat.com, galak@kernel.crashing.org
Subject: Re: [PATCH] Add "is_power_of_2" checking to log2.h.
References: <Pine.LNX.4.64.0701300543420.17991@CPE00045a9c397f-CM001225dbafb6> <45BF3954.8050106@yahoo.com.au> <Pine.LNX.4.64.0701300753170.23302@CPE00045a9c397f-CM001225dbafb6>
In-Reply-To: <Pine.LNX.4.64.0701300753170.23302@CPE00045a9c397f-CM001225dbafb6>
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Robert P. J. Day wrote:
> On Tue, 30 Jan 2007, Nick Piggin wrote:
> 
> 
>>Robert P. J. Day wrote:
>>
>>>  Add the inline function "is_power_of_2()" to log2.h, where the value
>>>zero is *not* considered to be a power of two.
>>
>>>Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
>>>
>>> /*
>>>+ *  Determine whether some value is a power of two, where zero is
>>>+ * *not* considered a power of two.
>>>+ */
>>
>>Why the qualifier? Zero *is* not a power of 2, is it?
> 
> 
> no, but it bears repeating since some developers might think it *is*.
> if you peruse the current kernel code, you'll find some tests of the
> simpler form:
> 
> 	((n & (n - 1)) == 0))
> 
> which is clearly testing for "power of twoness" but which will return
> true for a value of zero.  that's wrong, and it's why it's emphasized
> in the comment.

I would have thought you'd comment the broken ones, but that's just me.

-- 
SUSE Labs, Novell Inc.
Send instant messages to your online friends http://au.messenger.yahoo.com 
