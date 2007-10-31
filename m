Return-Path: <linux-kernel-owner+w=401wt.eu-S1754009AbXJaBQ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009AbXJaBQ0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2007 21:16:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752110AbXJaBQS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Oct 2007 21:16:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59480 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751981AbXJaBQR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2007 21:16:17 -0400
Message-ID: <4727D651.2010402@zytor.com>
Date: Tue, 30 Oct 2007 18:11:45 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Christoph Hellwig <hch@infradead.org>, Dave Jones <davej@redhat.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Sam Ravnborg <sam@ravnborg.org>
Subject: Re: 32bit builds on x86-64 host.
References: <20071029233231.GI7793@redhat.com> <472675AC.3070509@zytor.com> <20071030131032.GA32366@infradead.org> <4727D391.6080603@goop.org>
In-Reply-To: <4727D391.6080603@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> Christoph Hellwig wrote:
>> Which seems rather unnatural to me.  All other merge architectures have
>> ARCH=<archdir> where archdir is the name under arch, e.g. mips, powerpc,
>> s390.  They then have a CONFIG_FOO_64 and set the utsname and -m32/-m64
>> respectively.  It would be nice if x86 could behave like all other
>> architectures in this respect.  Especially as the behaviour of the other
>> architectures is a lot more intuitive.
>>   
> 
> Yes, that would be nice.  I keep forgetting the ARCH= in my crossbuild
> trees, and end up with strange mismashes.
> 

That, however, is a bigger problem that also affects, for example, 
compiling for MIPS on an x86 host.  I believe Sam is working on a 
solution for that.

(That doesn't mean that is not the right thing to do.)

	-hpa
