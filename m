Return-Path: <linux-kernel-owner+w=401wt.eu-S1757572AbYC1TWu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757572AbYC1TWu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 15:22:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754951AbYC1TWk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 15:22:40 -0400
Received: from smtp115.sbc.mail.sp1.yahoo.com ([69.147.64.88]:27379 "HELO
	smtp115.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756939AbYC1TWj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 15:22:39 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=pacbell.net;
  h=Received:X-YMail-OSG:X-Yahoo-Newman-Property:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id;
  b=I/G70BWbd5PsYGwNl32j0Tted4eoPA6/RcBM4SFV0gWdZ8RUi7I+NH6Q74i0TGvIg+fQe7D8mJnlY02Di6Lgx65ey4gEhPm7NK+93FonXq3tigs1unJpUCPTJPw6nBPiT5e+STf4KUZmGqxFhJnWxN/Femg2LZw0VfLjdqtgzvk=  ;
X-YMail-OSG: FAjxiFQVM1l7qJeY9b2Kuc_2Pr1X.rJMifuE6DMp0Hytwhup9.BTF.lJiFKnUYdm_jaTRs.O0Q--
X-Yahoo-Newman-Property: ymail-3
From: David Brownell <david-b@pacbell.net>
To: Tilman Schmidt <tilman@imap.cc>
Subject: Re: Kconfig RTC selection (was: 2.6.25-rc7: Ugh.)
Date: Fri, 28 Mar 2008 12:22:32 -0700
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, Mark Lord <lkml@rtr.ca>,
       David Miller <davem@davemloft.net>, jkosina@suse.cz, gregkh@suse.de,
       linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, pavel@suse.cz,
       akpm@linux-foundation.org, rtc-linux@googlegroups.com
References: <20080327160700.GB828@suse.de> <200803280249.42193.david-b@pacbell.net> <47ECE9BB.3050006@imap.cc>
In-Reply-To: <47ECE9BB.3050006@imap.cc>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803281222.33648.david-b@pacbell.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 March 2008, Tilman Schmidt wrote:
> 
> FWIW, it's still confusing to have an option "Enhanced Real Time
> Clock Support" under "Character Devices", then later an option
> "Real Time Clock" one level higher, none of the two in any way
> acknowledging the existence of the other one, and only after
> naively selecting both, you are told that there is some sort of
> conflict.

You mean "still, after applying that patch I sent"?  I don't
see how that could be; it doesn't allow both to be selected.


> Couldn't this be made more explicit, such as: 
> - mentioning in both options' help text that the other one
>    shouldn't be selected at the same time (if that's true)

I think that'd be more confusing, since it's not possible.
Telling people not to do something will usually make them
think it's possible ...


> - noting explicitly which of the two RTC options is the "legacy"
>    one (is it RTC_CLASS?)

That term isn't visible through the Kconfig user interfaces,
so I'm not sure why it should be introduced except as part
of a strategy to get rid of all those old drivers.  Which is
probably worth having, but isn't waht that patch addressed!


> - enhancing the conflict message, which reads, in git-current:
>         *** Conflicting RTC option has been selected, check GEN_RTC
>         *** RTC interfaces ***
>    Perhaps it's only me, but I do not know what to make of this.

Me either, since the patch I sent removed that message.
I'm now quite sure you did *NOT* apply and try that patch
before responding to it.

- Dave
