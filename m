Return-Path: <linux-kernel-owner+w=401wt.eu-S1759139AbZDOKJl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759139AbZDOKJl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 06:09:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753784AbZDOKJa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 06:09:30 -0400
Received: from yw-out-2324.google.com ([74.125.46.28]:19315 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753328AbZDOKJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 06:09:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=iHVB1k5o25xOgtDBE6LBMSKG3FlULvkJmmczD2dJVAiKvmdSy6lggZQfqnZmLoUueb
         ePvi/Lh4D/1oKoTtAl01H+aGFmj7eoyD87pHZuOCJnCN/8UyPvpq8WAQxM+ToxPe1FKB
         bpj1ZME2ada70khx8efcLYwiju4iCpDZifRw0=
Message-ID: <49E5B252.4030104@tuffmail.co.uk>
Date: Wed, 15 Apr 2009 11:09:22 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Thunderbird 2.0.0.21 (X11/20090318)
MIME-Version: 1.0
To: linux-pm@lists.linux-foundation.org
CC: USB list <linux-usb@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Regression: active uvcvideo breaks over suspend
References: <49E5B2F3.4080502@tuffmail.co.uk>
In-Reply-To: <49E5B2F3.4080502@tuffmail.co.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[removed from members-only mailing list]

Alan Jenkins wrote:
> I found this in v2.6.30-rc2.  I haven't tested beyond that.  I'm sure
> it didn't happen in 2.6.29.
>
> If I run "xawtv" and then suspend, it stops working on resume; the
> xawtv display goes black and the camera LED stays off.  When I close
> xawtv, the LED blinks on then off again.  If I then try to run xawtv
> again, it works fine.
>
> In dmesg (after resume) I see
>
> [  562.884298] usb 1-8: type resume
> [  562.990014] usb 1-8: reset high speed USB device using ehci_hcd and
> address 3
> [  563.665921] restoring control 00000000-0000-0000-0000-000000000101/0/2
> [  563.665935] restoring control 00000000-0000-0000-0000-000000000101/1/3
> [  563.665948] restoring control 00000000-0000-0000-0000-000000000101/3/7
> [  563.666412] uvcvideo 1-8:1.1: reset_resume error -12
>
> Thanks in advance
> Alan

