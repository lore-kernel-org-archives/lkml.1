Return-Path: <linux-kernel-owner+w=401wt.eu-S1755786AbZELJR1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755786AbZELJR1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 May 2009 05:17:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753484AbZELJRP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 12 May 2009 05:17:15 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:17332 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752284AbZELJRN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 May 2009 05:17:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nWg2CktEPZ+LmPYa3Plpk/vXkaKWfh9RZBUnk8XSRi19JWKOysqn/N5CxYZq6d9ikr
         oX+FErq25ymnoUQOt2LTSemYVQESnvYaqL71/UcjRElkSQI1FJ1LHe9ww8B3jR6noP0u
         qDctjKNwx+1m2m+BeTukLhhCSDsfmF7mA5q5o=
Message-ID: <4A093D1D.5060408@gmail.com>
Date: Tue, 12 May 2009 18:10:53 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Boaz Harrosh <bharrosh@panasas.com>
CC: axboe@kernel.dk, linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, James.Bottomley@HansenPartnership.com,
       linux-scsi@vger.kernel.org, bzolnier@gmail.com, petkovbb@googlemail.com,
       sshtylyov@ru.mvista.com, mike.miller@hp.com, Eric.Moore@lsi.com,
       stern@rowland.harvard.edu, fujita.tomonori@lab.ntt.co.jp,
       zaitcev@redhat.com, Geert.Uytterhoeven@sonycom.com,
       sfr@canb.auug.org.au, grant.likely@secretlab.ca,
       paul.clements@steeleye.com, tim@cyberelk.net, jeremy@xensource.com,
       adrian@mcmen.demon.co.uk, oakad@yahoo.com, dwmw2@infradead.org,
       schwidefsky@de.ibm.com, ballabio_dario@emc.com, davem@davemloft.net,
       rusty@rustcorp.com.au, Markus.Lidel@shadowconnect.com,
       Doug Gilbert <dgilbert@interlog.com>,
       "Darrick J. Wong" <djwong@us.ibm.com>
Subject: Re: [PATCH 03/11] block: add rq->resid_len
References: <1241423927-11871-1-git-send-email-tj@kernel.org> <1241423927-11871-4-git-send-email-tj@kernel.org> <4A06DFAB.40205@panasas.com> <4A0767E5.5050205@kernel.org> <4A080C9D.9000109@panasas.com> <4A08C26E.80801@kernel.org> <4A093782.80701@panasas.com> <4A093C54.2060706@kernel.org>
In-Reply-To: <4A093C54.2060706@kernel.org>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tejun Heo wrote:
...
> Please consider write failing after successfully writing certain
> number of bytes.  A failed write command MUST NOT cause any actual
> write on the device.
> 
> Residual count is not about how many bytes have been transferred.  The
> number of transferred bytes itself doesn't mean a thing because it
> changes depending on which transfer protocol is used regardless of
> where the actual failure is.  Residual count is about how many bytes
> have been actually produced or consumed and when a command fails none
> should have been.

Please note that in the above 'command' and 'residual count' are not
as defined in SCSI.  Those terms refer to how those concepts are used
in the kernel and via SG_IO interface.

Thanks.

-- 
tejun
