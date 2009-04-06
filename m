Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbZDFJEu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbZDFJEu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 05:04:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752197AbZDFJEl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 05:04:41 -0400
Received: from fg-out-1718.google.com ([72.14.220.157]:10591 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751407AbZDFJEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 05:04:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:to:cc:subject:references:from:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=iqt3cX1ttCda1yCRdtGWiBQUqnPZwcD3ucGtF5XwkExYRFa5wlCwynjYvUyLAWYe+Q
         1UIVUGPn4X+OGN5Jk0XoZzThcFL6sNuNvzzbiPUYRtQUWPQi1FcgARi6h5z0GlZIS2t/
         4KQNG+HdFxgNRfSsbz9Fq+W9jFuwD8/6Zd2Mg=
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Michael Buesch <mb@bu3sch.de>, Sujith <Sujith.Manoharan@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: ath9k becon loss messages
References: <1238923439.4120.9.camel@localhost.localdomain>
	<200904060914.32245.helmut.schaa@gmail.com>
	<873acmyz4x.fsf@litku.valot.fi>
	<200904061056.28495.helmut.schaa@gmail.com>
From: Kalle Valo <kalle.valo@iki.fi>
Date: Mon, 06 Apr 2009 12:04:35 +0300
In-Reply-To: <200904061056.28495.helmut.schaa@gmail.com> (Helmut Schaa's message of "Mon\, 6 Apr 2009 10\:56\:27 +0200")
Message-ID: <87y6uexie4.fsf@litku.valot.fi>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helmut Schaa <helmut.schaa@googlemail.com> writes:

>> > NetworkManager typically scans every 120 seconds and I can also trigger
>> > the messages by a manual scan with iwlist. I did not dig any further but
>> > the messages seem to appear right at the end of the scan. Tried with iwlagn
>> > and both sw_scan and hw_scan.
>> 
>> Thanks, this was valuable info. It might be that my beacon filtering
>> patches broke something related to scanning and beacon loss check. I'll
>> take a look at this.
>
> Maybe you did not break anything. During a scan we will stay away from the
> operating channel for some seconds which indeed prevents us from receiving
> beacons. I'd say sending a probe request to the AP in that case won't hurt.

Yeah, but it's ugly. And if the scan takes too long, for example over
four seconds, mlme would disconnect from AP. That's not good.

But I haven't looked at this in detail yet, just speculating here :)

-- 
Kalle Valo
