Return-Path: <linux-kernel-owner+w=401wt.eu-S1756615AbYC1Tzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756615AbYC1Tzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 15:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753931AbYC1Tzi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 15:55:38 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:49592
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752972AbYC1Tzh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 15:55:37 -0400
Message-Id: <47ED4D3102000078000493D7@public.id2-vpn.continvity.gns.novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 
Date: Fri, 28 Mar 2008 19:55:29 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: <mingo@elte.hu>
Cc: <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>, <hpa@zytor.com>
Subject: Re: [RFC] x86: bitops asm constraint fixes
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Ingo Molnar <mingo@elte.hu> 03/27/08 9:41 AM >>>
>
>* Jan Beulich <jbeulich@novell.com> wrote:
>
>> Please revert it for the time being, I've got a better version (i.e. 
>> without extra dead code being generated) that I intended to submit 
>> once I know whether the other issues pointed out in the description on 
>> the original patch also should be adjusted. Of course, that could also 
>> be done incrementally, but I would think overhauling the whole file at 
>> once wouldn't be a bad thing...
>
>since it appears to cause no problems in x86.git (it passed a lot of 
>testing already) i'd prefer to keep it (so that we can see any other 
>side-effects of touching this code) - could you send your improvements 
>as a delta against x86.git/latest? [or is there any outright bug caused 
>by your changes that necessiates a revert?]

That's fine with me (and no, there's no bug in there other than the
mentioned dead code generation).

Jan
