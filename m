Return-Path: <linux-kernel-owner+w=401wt.eu-S1755220AbZDFI4r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755220AbZDFI4r (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Apr 2009 04:56:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753694AbZDFI4j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Apr 2009 04:56:39 -0400
Received: from fk-out-0910.google.com ([209.85.128.185]:35146 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753174AbZDFI4i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Apr 2009 04:56:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=vzR16IMTSPFETHD60h81iBHgP9p0cW7JN3HaUNPgQqJZwrmyphp5/pkrue3O/5vazT
         BRMhDqfA6j13v8TjFObUrr6IWO5pytianLugncEA0SEL7VZ9+e7ndS7uWQFu27PwUVNe
         bKPb7mjl8ICVJe801rTinxChi9MRyQHjIm9CI=
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Kalle Valo <kalle.valo@iki.fi>
Subject: Re: ath9k becon loss messages
Date: Mon, 6 Apr 2009 10:56:27 +0200
User-Agent: KMail/1.9.10
Cc: Jaswinder Singh Rajput <jaswinder@kernel.org>,
       Michael Buesch <mb@bu3sch.de>, Sujith <Sujith.Manoharan@atheros.com>,
       wireless <linux-wireless@vger.kernel.org>,
       David Miller <davem@davemloft.net>, LKML <linux-kernel@vger.kernel.org>
References: <1238923439.4120.9.camel@localhost.localdomain> <200904060914.32245.helmut.schaa@gmail.com> <873acmyz4x.fsf@litku.valot.fi>
In-Reply-To: <873acmyz4x.fsf@litku.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200904061056.28495.helmut.schaa@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 6. April 2009 schrieb Kalle Valo:
> Helmut Schaa <helmut.schaa@googlemail.com> writes:
> 
> >> Then there is something happening in ath9k or your AP which prevents
> >> ath9k from receiving beacons. Try pinging your AP with 100 ms
> >> interval. Do you see anything happening in 120 s intervals?
> >
> > NetworkManager typically scans every 120 seconds and I can also trigger
> > the messages by a manual scan with iwlist. I did not dig any further but
> > the messages seem to appear right at the end of the scan. Tried with iwlagn
> > and both sw_scan and hw_scan.
> 
> Thanks, this was valuable info. It might be that my beacon filtering
> patches broke something related to scanning and beacon loss check. I'll
> take a look at this.

Maybe you did not break anything. During a scan we will stay away from the
operating channel for some seconds which indeed prevents us from receiving
beacons. I'd say sending a probe request to the AP in that case won't hurt.

Helmut
