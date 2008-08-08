Return-Path: <linux-kernel-owner+w=401wt.eu-S1757633AbYHHLUm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633AbYHHLUm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 07:20:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753101AbYHHLU1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 07:20:27 -0400
Received: from proxima.lp0.eu ([85.158.45.36]:49962 "EHLO proxima.lp0.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754600AbYHHLU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 07:20:26 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=exim; d=fire.lp0.eu;
	h=Received:Received:Message-ID:In-Reply-To:References:Date:Subject:From:To:Cc:User-Agent:MIME-Version:Content-Type:Content-Transfer-Encoding:X-Priority:Importance;
	b=ltjNKTl9efJKSbcHYBc8pi6vZyhy2j/+jPVNl42raOsAIvXAvfSEdDAB8enD+KpLq1p8OVyEddQSKG5er9EMQkP/QNUKydBUykatkhD6Qgl84dbk2H2Vqhduf4KRDyjM;
Message-ID: <21f16315cade48d9ecdc87a25b769b9f310fa112@8b5064a13e22126c1b9329f0dc35b8915774b7c3.invalid>
In-Reply-To: <20080808071430.GA10370@ucw.cz>
References: <48977AF7.2070300@simon.arlott.org.uk>
    <20080808071430.GA10370@ucw.cz>
Date: Fri, 8 Aug 2008 12:20:21 +0100
Subject: Re: [linux-pm] Tyan S2923-E suspend to ram fails to resume
From: "Simon Arlott" <simon@fire.lp0.eu>
To: "Pavel Machek" <pavel@suse.cz>
Cc: linux-pm@lists.linux-foundation.org,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
User-Agent: SquirrelMail/1.4.10a
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Priority: 3 (Normal)
Importance: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, August 8, 2008 08:14, Pavel Machek wrote:
> On Mon 2008-08-04 22:56:07, Simon Arlott wrote:
>> My system (Tyan S2923-E, dmesg attached) suspends ok in
>> all pm_test modes, but it won't resume with pm_test
>> "none".
>>
>> [    6.423515] mem full: hash matches
>>
>> When I press the power button, the port 80 display shows:
>> FF D0 23 01 D0 ... DE
>> (and again each time I press it)
>>
>> If I force it to turn off, then on again:
>> FF D0 23 01 D0 ... FF D0 23 01 D0 ... (D2?) D3 00 01 D5
>> D6 <normal boot>
>>
>> Any ideas? (onboard SAS is disabled, watchdog is
>> disabled, everything else is enabled, PCI-E graphics
>> card)
>
> Try verifying if it reaches assembly code under realmode/ ...

I was looking at the acpi code last night but I couldn't figure
out where the last code before the actual suspend is or where it
starts executing again.

I'm also not sure how to do it, could you provide a quick patch
that immediately writes something to port 80 before doing
anything else?


-- 
Simon Arlott
