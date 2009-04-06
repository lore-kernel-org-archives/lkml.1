Return-Path: <linux-kernel-owner+w=401wt.eu-S1755130AbZDFIRw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755130AbZDFIRw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 04:17:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752539AbZDFIRn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 04:17:43 -0400
Received: from mail-bw0-f169.google.com ([209.85.218.169]:39191 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752062AbZDFIRm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 04:17:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=mLOVobRXHJWg0/ZbewF0sjgjsh1pZnVIhFakKb2ePknfec4bd8Y2A0qHHvEqoWq01L
         o5vIk1BzH/nMVxErMFSEGqSnZ5OKB0repZfMWjnw/KwJ+Dq2mWtLFvnOtrboV7MYhid8
         C/M0nT6e9yfMPJaqzkTU6VESh8UnWBNvS1Yk0=
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Michael Buesch <mb@bu3sch.de>, Sujith <Sujith.Manoharan@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ath9k becon loss messages
References: <1238923439.4120.9.camel@localhost.localdomain>
	<1238925174.4120.12.camel@localhost.localdomain>
	<87bprbif2f.fsf@litku.valot.fi>
	<200904060914.32245.helmut.schaa@gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 06 Apr 2009 11:17:34 +0300
In-Reply-To: <200904060914.32245.helmut.schaa@gmail.com> (Helmut Schaa's message of "Mon\, 6 Apr 2009 09\:14\:31 +0200")
Message-ID: <873acmyz4x.fsf@litku.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helmut Schaa <helmut.schaa@googlemail.com> writes:

>> Then there is something happening in ath9k or your AP which prevents
>> ath9k from receiving beacons. Try pinging your AP with 100 ms
>> interval. Do you see anything happening in 120 s intervals?
>
> NetworkManager typically scans every 120 seconds and I can also trigger
> the messages by a manual scan with iwlist. I did not dig any further but
> the messages seem to appear right at the end of the scan. Tried with iwlagn
> and both sw_scan and hw_scan.

Thanks, this was valuable info. It might be that my beacon filtering
patches broke something related to scanning and beacon loss check. I'll
take a look at this.

-- 
Kalle Valo
