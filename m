Return-Path: <linux-kernel-owner+w=401wt.eu-S1754127AbYKRQ34@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754127AbYKRQ34 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2008 11:29:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752844AbYKRQ3h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Nov 2008 11:29:37 -0500
Received: from wa-out-1112.google.com ([209.85.146.183]:32499 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbYKRQ3g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2008 11:29:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=QqjePYDDQlRGM0iKX+f5pp5nwaIjCWG4Xax3QYwGf4DawURjGnGzBceMKc435Z9qUe
         qgLwfmyHg+aRK1PHdRbR1ro6uE2+RGTFApv0N060yNag4WzKzswbcXsaKvrApy00Z5vO
         xJrO/KSHXrs+uZG2QetaEyZMzCjGGcwo/x2B0=
Subject: Re: [ 11.333737] is this a ghost?
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <9b2b86520811180315u410019f0y7e6fab66b51a225e@mail.gmail.com>
References: <1227001038.3184.6.camel@LiNuX>
	 <9b2b86520811180315u410019f0y7e6fab66b51a225e@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 18 Nov 2008 08:29:31 -0800
Message-Id: <1227025771.3161.6.camel@LiNuX>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-11-18 at 11:15 +0000, Alan Jenkins wrote:
> On 11/18/08, Justin P. Mattock <justinmattock@gmail.com> wrote:
> > in dmesg I see:
> > [   11.333737]
> > but nothing else.
> >           ---------------(cut)-----------------
> > [   11.247147] Monitor-Mwait will be used to enter C-1 state
> > [   11.247151] Monitor-Mwait will be used to enter C-2 state
> > [   11.247154] Monitor-Mwait will be used to enter C-3 state
> > [   11.247671] ACPI: CPU0 (power states: C1[C1] C2[C2] C3[C3])
> > [   11.247996] processor ACPI_CPU:00: registered as cooling_device0
> > [   11.248008] ACPI: Processor [CPU0] (supports 8 throttling states)
> > [   11.306465] ACPI: SSDT 3FEB8F10, 0087 (r1 APPLE   Cpu1Ist     3000
> > INTL 20050309)<7>power_supply ADP1: No power supply yet
> 
> Look at this last line.  The "<7>" is a priority marker.  Normally it
> marks the start of a line, and should be hidden.  So you seem to be
> missing a line break just after "20050309)"...
> 
> > [   11.306831] power_supply ADP1: power_supply_changed
> > [   11.306839] ACPI: AC Adapter [ADP1] (on-line)
> > [   11.333737]                         <------------what's with this!!!
> 
> ...which seems to be delayed and reappears here?
> 
> > [   11.342937] power_supply ADP1: power_supply_changed_work
> > [   11.351901] power_supply ADP1: power_supply_update_gen_leds 1
> > [   11.351916] ACPI: SSDT 3FEB7F10, 0085 (r1 APPLE   Cpu1Cst     3000
> > INTL 20050309)
> 
> > if you need to see the full dmesg I can attach..
> > I've seen this happen on a random.
> 
> I guess you have a multicore processor (or some other sort of SMP), right?
> 
> I think kernel messages are not completely synchronized by design, for
> reliability reasons.  (e.g. to make sure critical error messages /
> backtraces can get through on a dying system).


Cool.
makes good sense to me, 
As long as it's not something that shouldn't be there,
or something that's broken. As for this happening again
looking at dmesg nothing, all synchronized.
Seems to randomly show itself.

regards;
  
-- 
Justin P. Mattock <justinmattock@gmail.com>

