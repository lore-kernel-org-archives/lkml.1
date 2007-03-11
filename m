Return-Path: <linux-kernel-owner+w=401wt.eu-S933626AbXCKOCj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933626AbXCKOCj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2007 10:02:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933629AbXCKOCj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Mar 2007 10:02:39 -0400
Received: from ug-out-1314.google.com ([66.249.92.171]:27599 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933622AbXCKOCi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2007 10:02:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=d24dkFdFenwjkCI12LiBj2PwHiyBicb3kYSkeA3JxQIl06ZJn+1NI/i15C/Nr+mfYJUTGJdIwfIFQb2AyI/q/54Anxt6t2yRdGDX6M9WiH1nHvy87adCko9PHCd+8xieD1SYoCJKhjQC4neY1rGWfqt2BMHrW7rKKdfley5WPRs=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Vitaliyi <imgrey@gmail.com>
Subject: Re: libata extension
Date: Sun, 11 Mar 2007 15:09:38 +0100
User-Agent: KMail/1.9.6
Cc: linux-kernel@vger.kernel.org
References: <3aac340703102322p362998b9labedc13503702d2b@mail.gmail.com>
In-Reply-To: <3aac340703102322p362998b9labedc13503702d2b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200703111509.38642.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


Hi,

On Sunday 11 March 2007, Vitaliyi wrote:
> Good Day
> 
> Say i want to implement extended set of ATA commands available to
> userspace for building diagnostic tools.
> I need 0x40 -- read verify and 0x32 -- write long with error handling,

Mark Lord is working on READ/WRITE_LONG support for libata,
he has posted draft patch recently on linux-ide mailing list.

[ Please consider reading/joining linux-ide@vger.kernel.org ML,
  it is where Linux ATA discussion happens... ]

> for example. I was trying ide driver through ioctl's, but seems it
> lack of functionality and full of gotchas. Furthermore it oopses
> sometimes.

READ/WRITE_LONG is unsupported and as you've already noticed
TASKFILE ioctls are full of gotchas...

> Is it possible to use libata for such purpose or i need to write
> separate IDE driver ?

It should be possible using ATA pass-through, some libata changes
may be required but it is the right way to go IMO.

Bart
