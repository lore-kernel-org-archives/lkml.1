Return-Path: <linux-kernel-owner+w=401wt.eu-S1756153AbYA1UpN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153AbYA1UpN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:45:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752226AbYA1Uo7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:44:59 -0500
Received: from gw.goop.org ([64.81.55.164]:41338 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbYA1Uo6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:44:58 -0500
Message-ID: <479E3EC6.5070800@goop.org>
Date: Mon, 28 Jan 2008 12:44:54 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Pavel Machek <pavel@ucw.cz>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, Ian Campbell <ijc@hellion.org.uk>,
       =?ISO-8859-1?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <200801281625.45165.rjw@sisk.pl> <20080128194017.GA4481@ucw.cz> <200801282126.45751.rjw@sisk.pl>
In-Reply-To: <200801282126.45751.rjw@sisk.pl>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Rafael J. Wysocki wrote:
> Actually, no.  We only do that with the kernel code mapping which should be
> safe as long as TLBs are not flushed (and they aren't).
>   

Er, what?  Assuming the TLB will retain some mappings while you 
overwrite the pagetable is a highly dubious prospect.  Are you copying 
the same values over, or something else?

    J
