Return-Path: <linux-kernel-owner+w=401wt.eu-S1765164AbYCDQHj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765164AbYCDQHj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 11:07:39 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762461AbYCDQHb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 11:07:31 -0500
Received: from gw.goop.org ([64.81.55.164]:35747 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754909AbYCDQHa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 11:07:30 -0500
Message-ID: <47CD7290.1040907@goop.org>
Date: Tue, 04 Mar 2008 08:02:24 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mark McLoughlin <markmc@redhat.com>, Ian Campbell <ijc@hellion.org.uk>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Alexander van Heukelum <heukelum@mailshack.com>,
       Alexander van Heukelum <heukelum@fastmail.fm>, Andi Kleen <ak@suse.de>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] use realmode code to reserve end-of-conventional-memory
 to 1MB
References: <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com> <20080228131341.GA25213@mailshack.com> <20080228132822.GA25278@mailshack.com> <1204233131.28798.12.camel@cthulhu.hellion.org.uk> <47C72432.3010606@zytor.com> <1204240609.28798.33.camel@cthulhu.hellion.org.uk> <1204630906.16613.4.camel@muff> <20080304143324.GA2713@elte.hu> <47CD672C.1040406@goop.org> <20080304152540.GC6449@elte.hu>
In-Reply-To: <20080304152540.GC6449@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
>> I think it was a side effect of all the early_ioremap work, which 
>> changed the order in which things happened at boot time.
>>     
>
> which commits do you mean in particular?

Good question.  It might have been cpa as well.  I'd have to look 
through to confirm the theory, but I think Xen got broken for other 
reasons around there, so simple bisect wouldn't be enough to identify 
the problem.

    J
