Return-Path: <linux-kernel-owner+w=401wt.eu-S1756901AbXHTAUS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756901AbXHTAUS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2007 20:20:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754895AbXHTATw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 19 Aug 2007 20:19:52 -0400
Received: from smtp101.sbc.mail.re2.yahoo.com ([68.142.229.104]:45274 "HELO
	smtp101.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754785AbXHTATv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2007 20:19:51 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=VSMtiRIrhmwR2Ip+OmMxov0USREShEa98KLzAz2CVuogy5Z2SjDSQszou7BXYpzNHW6YgX/nM7NlM9RVIqniiOE3c47HCErQkEmGESIjgbFPoONW1JmhsJT6YtckNHKrsObL+0OXBWZtByV4vOkY6HZfLe0spMF29GEYu1QAR/s=  ;
X-YMail-OSG: 4gPXXF0VM1kJxs3QKge7E4dyzyBiIIf0nhqf02jcDeL1WpUmeaEIXGJMkbKSATP3s66I7Dxy_Q--
From: David Brownell <david-b@pacbell.net>
To: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: [PATCH] ptrdiff_t is not uintptr_t, damnit
Date: Sun, 19 Aug 2007 17:19:47 -0700
User-Agent: KMail/1.9.6
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org
References: <20070819225546.GV21089@ftp.linux.org.uk>
In-Reply-To: <20070819225546.GV21089@ftp.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200708191719.48340.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 19 August 2007, Al Viro wrote:
> is wrong; for one thing, it's a bad C (it's what uintptr_t is for; in general
> we are not even promised that ptrdiff_t is large enough to hold a pointer,

ISTR we don't *have* a uintptr_t on all architectures, or that would
be the appropriate thing to use in these 32/64 bit ABI scenarios.


> Use unsigned long or uintptr_t instead. 

I suspect you mean "unsigned long long"...

- Dave
