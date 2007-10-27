Return-Path: <linux-kernel-owner+w=401wt.eu-S1757835AbXJ0Stk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757835AbXJ0Stk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 14:49:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752015AbXJ0Std
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 14:49:33 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33884 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958AbXJ0Std (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 14:49:33 -0400
Message-ID: <472387F5.8020409@zytor.com>
Date: Sat, 27 Oct 2007 11:48:21 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: Andy Whitcroft <apw@shadowen.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Randy Dunlap <rdunlap@xenotime.net>, tglx@linutronix.de,
       nickpiggin@yahoo.com.au, mingo@redhat.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org
Subject: Re: [PATCH v2] bitops kernel-doc: inline instead of macro
References: <20071023220959.a359d57d.rdunlap@xenotime.net> <200710241800.19764.nickpiggin@yahoo.com.au> <20071025093159.3ea69d03.rdunlap@xenotime.net> <alpine.LFD.0.9999.0710251840530.3186@localhost.localdomain> <20071025095540.827d4333.rdunlap@xenotime.net> <20071025134814.caced2e3.akpm@linux-foundation.org> <20071027104328.GA5529@shadowen.org>
In-Reply-To: <20071027104328.GA5529@shadowen.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andy Whitcroft wrote:
> On Thu, Oct 25, 2007 at 01:48:14PM -0700, Andrew Morton wrote:
> 
>> Andy, I thought we were going to whine about __inline__ and __inline, too?
> 
> Hmmm, I don't remember that coming up, but I'll add it to the todo.  I
> am assuming plain 'inline' is preferred over both of these -- yell if
> you meant something else.

Yes, use __inline__ if and only if it is exported to userspace.

	-hpa
