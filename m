Return-Path: <linux-kernel-owner+w=401wt.eu-S1761906AbYCCEOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761906AbYCCEOW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2008 23:14:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757289AbYCCEOO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 2 Mar 2008 23:14:14 -0500
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:30714 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757054AbYCCEOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2008 23:14:14 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=wisUwuylA6AhbzE1ZclFtDIFSnRWoZUS6JEZIjVRUNuq5RAqzKV+jnIzGvAZmm8e2Zkf+jAh1dnsJuS60DaA+jOGWvZHfL386XWQ0tCOltNVJqmL3HN/qVN8uKJbHcohl8i44HUH/l7XSDHXZnZNnxBlTNs84XLABQ3rLwRwGoA=  ;
X-YMail-OSG: XyyEmAEVM1mFpMrEud1QVzE6Wr3VC5DmULGEJXC5W7UBMrPF6_TzaRcZt345mrKfORRsya15uA--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [PATCH 1/2] Add C99-style constructor macros for specific-sized integers
Date: Sun, 2 Mar 2008 20:14:11 -0800
User-Agent: KMail/1.9.6
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Arch Mailing List <linux-arch@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <4a8566f54ff84f498c5c0c0340076c296b1840e6@tazenda.hos.anvin.org> <7e0381d9932a37ad78f0c38b2a3c6a03@kernel.crashing.org>
In-Reply-To: <7e0381d9932a37ad78f0c38b2a3c6a03@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803022014.11535.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 02 March 2008, Segher Boessenkool wrote:

> Do these new macros really buy anything over just writing LL in the
> few places that 64-bit constants are used?

The original workaround was to make the offending *SEC_TO_HZ_ADJ32
constants use "ULL" suffixes.  Certainly making the Perl script emit
those would be less intrusive.

- Dave

