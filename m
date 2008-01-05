Return-Path: <linux-kernel-owner+w=401wt.eu-S1756875AbYAESmg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875AbYAESmg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jan 2008 13:42:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756137AbYAESm2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 5 Jan 2008 13:42:28 -0500
Received: from japan.chezphil.org ([77.240.5.4]:1874 "EHLO japan.chezphil.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756135AbYAESm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jan 2008 13:42:28 -0500
To: "Andi Kleen" <andi@firstfloor.org>
Cc: <linux-kernel@vger.kernel.org>
Date: Sat, 05 Jan 2008 18:42:24 +0000
Subject: Re: strace, accept(), ERESTARTSYS and EINTR
Message-ID: <1199558544071@dmwebmail.japan.chezphil.org>
In-Reply-To: <p731w8w8gcw.fsf@bingen.suse.de>
References: <p731w8w8gcw.fsf@bingen.suse.de>
X-Mailer: Decimail Webmail 3alpha16
MIME-Version: 1.0
Content-Type: text/plain; format="flowed"
From: "Phil Endecott" <phil_wueww_endecott@chezphil.org>
X-SPF-Guess: pass
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen wrote:
> "Phil Endecott" <phil_wueww_endecott@chezphil.org> writes:
>>
>> Many thanks for any suggestions.
>
> It's a long standing bug reported regularly

Thanks for the re-assurance.

> but so far nobody has tracked 
> it down. That's mostly because most people cannot really reproduce it.

I'm pretty sure that it's triggered by some earlier problem, most 
likely reaching a threads-per-process limit (or an associated total VM 
per process limit due to large default thread stack sizes).  There's a 
good chance that I will find and fix that problem, and this one will 
then go away unsolved...

> If you can reproduce it reliably
[snip]
> definitely don't do it on a production machine

Unfortunately, it happens on the production machine but I've not been 
able to reproduce it otherwise.  I'll keep trying.  FWIW my assumption 
is that the ERESTARTSYS comes from the sock_intr_errno() call from inet_csk_wait_for_connect().


Thanks,  Phil.




