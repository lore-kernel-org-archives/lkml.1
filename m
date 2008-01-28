Return-Path: <linux-kernel-owner+w=401wt.eu-S1754982AbYA1UDu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754982AbYA1UDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 15:03:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750828AbYA1UDm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 15:03:42 -0500
Received: from gw.goop.org ([64.81.55.164]:54711 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813AbYA1UDl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 15:03:41 -0500
Message-ID: <479E3519.4070105@goop.org>
Date: Mon, 28 Jan 2008 12:03:37 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Ingo Molnar <mingo@elte.hu>, Ian Campbell <ijc@hellion.org.uk>,
       =?ISO-8859-1?Q?Mika_Penttil=E4?= <mika.penttila@kolumbus.fi>,
       linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH] x86: Construct 32 bit boot time page tables in native
 format.
References: <1201167544.30671.64.camel@cthulhu.hellion.org.uk> <200801252302.52164.rjw@sisk.pl> <20080128150022.GE27928@elte.hu> <200801281625.45165.rjw@sisk.pl> <20080128194017.GA4481@ucw.cz> <479E3248.40409@zytor.com>
In-Reply-To: <479E3248.40409@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
>  and we already have to have code to synchronize the PGDs on !PAE and 
> the PMDs on Xen (although that was supposedly getting fixed).

No, I don't have any plans there.  Xen will continue to require 
non-shared kernel pmd, at least for a 32-bit host.  I think the point is 
that nothing that requires an identity mapping will work under Xen 
anyway, so Xen just doesn't care about this case.

    J
