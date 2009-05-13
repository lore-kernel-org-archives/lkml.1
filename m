Return-Path: <linux-kernel-owner+w=401wt.eu-S1758736AbZEMPaV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736AbZEMPaV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 11:30:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756887AbZEMPaF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 11:30:05 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:62051 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756444AbZEMPaE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 11:30:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=CaVmK3sy2t6ZRZAn/2khsYwQeoFBa3YahJ7rwT32s1rmoZxO6il8NFa25R4yxDIIwM
         hzHti3ZQFbAbE5N1jSARO9dEBsQkRE4ppnu2aIVcFf8C3CUMLVz38nQ/X7SQGeSNeMRd
         KBcpN8cBFXRnsIOFJyOghZTDtpQjfVk6ye3K0=
MIME-Version: 1.0
In-Reply-To: <200905131015.45635.rjw@sisk.pl>
References: <20090507105821.GA5864@hash.localnet>
	 <d3f22a0905122245h15786220g31ad0dcb8caa3a38@mail.gmail.com>
	 <1242192968.14626.40.camel@minggr.sh.intel.com>
	 <200905131015.45635.rjw@sisk.pl>
Date: Wed, 13 May 2009 11:30:02 -0400
X-Google-Sender-Auth: 67f1efa28b5628a9
Message-ID: <b6c5339f0905130830k3549095dv3eee08d7d3155a37@mail.gmail.com>
Subject: Re: [BISECTED] Was Re: acpi/suspend - irq 9: nobody cared
From: Bob Copeland <me@bobcopeland.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Lin Ming <ming.m.lin@intel.com>, Bjorn Helgaas <bjorn.helgaas@hp.com>,
       yakui_zhao <yakui.zhao@intel.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "Moore, Robert" <robert.moore@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/5/13 Rafael J. Wysocki <rjw@sisk.pl>:
>> So we preserve SCI_EN bit per spec.
>
> In fact we do set SCI_EN directly in drivers/acpi/sleep.c in a couple of
> places exactly because the hardware is _known_ to wrong things here.  So, we
> don't really preserve it, _exactly_ because at least some pieces of hardware
> out there don't follow the spec.  Including Macs, IIRC.
>
> Bob, can you please verify if the Lin Ming's patch helps?

Yes, my laptop is one of those pieces of hardware.  I can confirm that Lin
Ming's patch works on my system.

-- 
Bob Copeland %% www.bobcopeland.com
