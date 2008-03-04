Return-Path: <linux-kernel-owner+w=401wt.eu-S1764652AbYCDPTF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764652AbYCDPTF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 10:19:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757978AbYCDPSz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 10:18:55 -0500
Received: from gw.goop.org ([64.81.55.164]:47706 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758287AbYCDPSy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 10:18:54 -0500
Message-ID: <47CD672C.1040406@goop.org>
Date: Tue, 04 Mar 2008 07:13:48 -0800
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
References: <47C22568.1010405@zytor.com> <1203958478.20033.1239002461@webmail.messagingengine.com> <20080225170134.GA15839@elte.hu> <20080225180750.GA31054@mailshack.com> <20080228131341.GA25213@mailshack.com> <20080228132822.GA25278@mailshack.com> <1204233131.28798.12.camel@cthulhu.hellion.org.uk> <47C72432.3010606@zytor.com> <1204240609.28798.33.camel@cthulhu.hellion.org.uk> <1204630906.16613.4.camel@muff> <20080304143324.GA2713@elte.hu>
In-Reply-To: <20080304143324.GA2713@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> i'm wondering, what triggered this bug, and why didnt we have these 
> problems in the past?

I think it was a side effect of all the early_ioremap work, which 
changed the order in which things happened at boot time.

    J
