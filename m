Return-Path: <linux-kernel-owner+w=401wt.eu-S1756607AbYA1ULS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607AbYA1ULS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:11:18 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751480AbYA1ULG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:11:06 -0500
Received: from terminus.zytor.com ([198.137.202.10]:49849 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbYA1ULD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:11:03 -0500
Message-ID: <479E35DB.2010702@zytor.com>
Date: Mon, 28 Jan 2008 12:06:51 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Ian Campbell <ijc@hellion.org.uk>,
       =?ISO-8859-1?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <200801252302.52164.rjw@sisk.pl> <20080128150022.GE27928@elte.hu> <200801281625.45165.rjw@sisk.pl> <20080128194017.GA4481@ucw.cz> <479E3248.40409@zytor.com> <479E3519.4070105@goop.org>
In-Reply-To: <479E3519.4070105@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>>  and we already have to have code to synchronize the PGDs on !PAE and 
>> the PMDs on Xen (although that was supposedly getting fixed).
> 
> No, I don't have any plans there.  Xen will continue to require 
> non-shared kernel pmd, at least for a 32-bit host.  I think the point is 
> that nothing that requires an identity mapping will work under Xen 
> anyway, so Xen just doesn't care about this case.
> 

Still makes it a special case, not just for this.

	-hpa
