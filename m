Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbZKJTPc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbZKJTPc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Nov 2009 14:15:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757795AbZKJTPb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Nov 2009 14:15:31 -0500
Received: from zrtps0kp.nortel.com ([47.140.192.56]:39135 "EHLO
	zrtps0kp.nortel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757786AbZKJTPa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Nov 2009 14:15:30 -0500
Message-ID: <4AF9BB2A.7060109@nortel.com>
Date: Tue, 10 Nov 2009 13:12:42 -0600
From: "Chris Friesen" <cfriesen@nortel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
CC: James Bottomley <James.Bottomley@HansenPartnership.com>,
       Greg KH <gregkh@suse.de>, Ingo Molnar <mingo@elte.hu>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC] new -stable tag variant, Git workflow question
References: <20091110034831.GB26809@elte.hu>	 <20091110041452.GA25575@suse.de> <1257863388.4184.220.camel@mulgrave.site> <4AF98C36.9040405@s5r6.in-berlin.de>
In-Reply-To: <4AF98C36.9040405@s5r6.in-berlin.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 10 Nov 2009 19:14:04.0497 (UTC) FILETIME=[F7E2BC10:01CA6239]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/2009 09:52 AM, Stefan Richter wrote:

> More importantly, isn't this against the character of the -stable kernel
> branches as _safe and simple_ hotfix branches?
> 
> If a fix has a number of prerequisites which ar not -stable fixes
> themselves, then it is more than a hint that this fix is not really well
> suited for -stable.

Alternately, it's conceivable that the prerequisites were not
in-and-of-themselves candidates for -stable (maybe they didn't do
anything by themselves) but when combined with the final commit the
overall change is suitable for inclusion in -stable.

Chris
