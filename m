Return-Path: <linux-kernel-owner+w=401wt.eu-S1762111AbXHACJE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762111AbXHACJE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2007 22:09:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753779AbXHACIx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 31 Jul 2007 22:08:53 -0400
Received: from nf-out-0910.google.com ([64.233.182.187]:20878 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753718AbXHACIw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2007 22:08:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=ePWiJh0Bvq7VyIAMgX48elRM2N6ZAaKWu7KJ0OIIG5v0MJrHqPuOtmuudcJeFvF5Y9KgBk+q96fst8L7b3vvRDu41FRIw/Nx6hlWJK4sYt5GcgCNwK2sizNqzolm+OEusFxSHdfjpXZGan5q7Sd7V0XTfEwSIdtEgacHLDYY2L4=
Message-ID: <46AFEB21.1040802@googlemail.com>
Date: Wed, 01 Aug 2007 04:08:33 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: "Antonino A. Daplas" <adaplas@gmail.com>
CC: Daniel Drake <dsd@gentoo.org>, Zwane Mwaikambo <zwane@infradead.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jan Beulich <jbeulich@novell.com>, linux-kernel@vger.kernel.org,
       Andi Kleen <ak@suse.de>
Subject: Re: [PATCH] retrieve VBE EDID/DDC info independent of used video
 mode
References: <4678191D.76E4.0078.0@novell.com> <4686D85B.6090803@gentoo.org>	 <20070630154230.4ad373fa.akpm@linux-foundation.org>	 <4690E65B.5050607@gentoo.org>	 <20070708111404.1486e73c.akpm@linux-foundation.org>	 <46912E09.2070806@zytor.com> <4692BC61.9070500@gentoo.org>	 <4692BDEE.8020802@zytor.com> <4693BF02.2050705@gentoo.org>	 <4693C0A1.8010901@zytor.com> <4693CAFF.4000609@gentoo.org>	 <4693CCC6.7050400@zytor.com> <46AFCCBB.70307@gentoo.org>	 <Pine.LNX.4.64.0707311719540.5207@montezuma.windriver.com>	 <46AFDF3A.6080300@gentoo.org> <1185933291.4688.11.camel@daplas>
In-Reply-To: <1185933291.4688.11.camel@daplas>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Antonino A. Daplas wrote:
> On Tue, 2007-07-31 at 21:17 -0400, Daniel Drake wrote:
>> Zwane Mwaikambo wrote:
>>> Sorry if this has been hashed out before, but could you point me towards 
>>> the gentoo bugzilla entry? I'm trying to understand how your setup broke. 
>>> Which version VBE does your system have?
>> Here's the bug:
>> http://bugs.gentoo.org/show_bug.cgi?id=181067
>>
> 
> Looking at the dmesg output of the working and failing kernel, it does
> seem that there's no EDID block available in the failing kernel.
> 
>> How can we identify the VBE version?

You could use http://john.fremlin.de/programs/linux/read-edid/ and you get the EDID and VBE version


Regards,

Gabriel
