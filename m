Return-Path: <linux-kernel-owner+w=401wt.eu-S1946049AbXEAXYb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946049AbXEAXYb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 May 2007 19:24:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1423508AbXEAXYb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 May 2007 19:24:31 -0400
Received: from smtpq2.tilbu1.nb.home.nl ([213.51.146.201]:34425 "EHLO
	smtpq2.tilbu1.nb.home.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423504AbXEAXYa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 May 2007 19:24:30 -0400
Message-ID: <4637CB9F.9010408@gmail.com>
Date: Wed, 02 May 2007 01:22:07 +0200
From: Rene Herman <rene.herman@gmail.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070221)
MIME-Version: 1.0
To: Vlad <vladc6@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: arch/i386/boot rewrite, and all the hard-coded video cards
References: <741290.4122.qm@web54405.mail.yahoo.com>
In-Reply-To: <741290.4122.qm@web54405.mail.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
X-AtHome-MailScanner-Information: Please contact support@home.nl for more information
X-AtHome-MailScanner: Found to be clean
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2007 12:41 AM, Vlad wrote:

> H. Peter Anvin wrote:

>> I'm rewriting the i386 setup code in C, instead of assembly,
>> and before I spend a very large amount of time translating
>> all the various card-specific probes, I want to ask the
>> following question...
>>
>> Does *anyone* care about these anymore?
> 
> Yes, booting Linux on old i386/i486 hardware is still very useful for
> forensic purposes and recovering important data. I've personally had
> to do this many times, and I'm sure others have as well.
> 
> Booting is such a critical process that a user would be completely
> lost as to why it fails, especially if they can't see any output on
> the screen. I think it would be a shame to prevent Linux from running
> on these machines.

He wasn't asking about doing away with all video output on 386/486s, but 
with special Super VGA adapter specific modes. You'd have normal VGA 
available as always, and VESA if the videocard supports it (which all cards 
that _can_ do more than 80x25 do).

Rene.

