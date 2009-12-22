Return-Path: <linux-kernel-owner+w=401wt.eu-S1751870AbZLVNwo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751870AbZLVNwo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Dec 2009 08:52:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751037AbZLVNwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Dec 2009 08:52:43 -0500
Received: from mail-ew0-f219.google.com ([209.85.219.219]:49035 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750841AbZLVNwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Dec 2009 08:52:42 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=FcaHGMYiWk28QHQThhcIm9zVHzQdCEKKgHhUJYWCECph2Da0ZbtKfLa5Y5BpJZQXJQ
         tGNF0HmHRUWZ3rX0xI0W56O9JVwA4Z+GljvOBEUG47ioELCWbrYDZrecvxYim9DrK9dl
         Q6vwszwWcI8OfhhsHCu/wWym7OYY0yRmG5K9I=
Message-ID: <4B30D2FE.9020209@gmail.com>
Date: Tue, 22 Dec 2009 14:09:02 +0000
From: Dave Korn <dave.korn.cygwin@googlemail.com>
User-Agent: Thunderbird 2.0.0.17 (Windows/20080914)
MIME-Version: 1.0
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
CC: Richard Henderson <rth@redhat.com>,
       Richard Guenther <richard.guenther@gmail.com>,
       David Daney <ddaney@caviumnetworks.com>,
       "gcc@gcc.gnu.org" <gcc@gcc.gnu.org>, Jamie Lokier <jamie@shareable.org>,
       linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       =?ISO-8859-1?Q?Uwe_Kleine-K=F6ni?= =?ISO-8859-1?Q?g?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH] ARM: Convert BUG() to use unreachable()
References: <1260266138-17684-1-git-send-email-u.kleine-koenig@pengutronix.de> <20091217150120.GD24967@shareable.org> <4B2A65C6.7080009@caviumnetworks.com> <84fc9c000912170917y4b2772d0n47bb4dabc74b91ef@mail.gmail.com> <20091217181718.GA4440@n2100.arm.linux.org.uk> <4B2FCCE3.1090209@redhat.com> <20091221201059.GD11669@n2100.arm.linux.org.uk>
In-Reply-To: <20091221201059.GD11669@n2100.arm.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Russell King - ARM Linux wrote:
> On Mon, Dec 21, 2009 at 11:30:43AM -0800, Richard Henderson wrote:
>> On 12/17/2009 10:17 AM, Russell King - ARM Linux wrote:
>>> How is "size-optimal trap" defined?
>> E.g. Sparc and MIPS have "tcc" instructions that trap based on the
>> condition codes, and so we eliminate the branch.  That's the only
>> optimization we apply with __builtin_trap.
>>
>>> Let me put it another way: I want this function to terminate with an
>>> explicit NULL pointer dereference in every case.
>> Then just use that.
> 
> That's precisely what we have been using for many years.

  I don't understand.  It should still work just fine; the original version
posted appears to simply lack 'volatile' on the (int *) cast.

    cheers,
      DaveK
