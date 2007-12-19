Return-Path: <linux-kernel-owner+w=401wt.eu-S1753991AbXLSMuc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753991AbXLSMuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 07:50:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752245AbXLSMuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 07:50:22 -0500
Received: from py-out-1112.google.com ([64.233.166.179]:16157 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752092AbXLSMuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 07:50:21 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=audTP04bG8AJcleUw5prhLJjnEyFReEk91C78mBfRO9p1DEW4z40b9teK6eGi9pZFOz0qMSxJB1WBt+d3HBRlzePk9LG03rz0Z9R95Z7/JVgJZqNJ/vgSkAdnR5cqpHzV8Pb/e2AwGQQJnHsm8A58r54IroRPODOJrQdKA7+Fg4=
Message-ID: <3efb10970712190450p64d4e7a2k7b80d47349be9570@mail.gmail.com>
Date: Wed, 19 Dec 2007 13:50:16 +0100
From: "Remy Bohmer" <linux@bohmer.net>
To: "Haavard Skinnemoen" <hskinnemoen@atmel.com>
Subject: Re: [PATCH] atmel_serial: Split the interrupt handler
Cc: "Andrew Victor" <linux@maxim.org.za>,
       "ARM Linux Mailing List" <linux-arm-kernel@lists.arm.linux.org.uk>,
       "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20071219133411.24d146e7@dhcp-252-066.norway.atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1197987255-23045-1-git-send-email-hskinnemoen@atmel.com>
	 <3efb10970712180723x2cd22c5ei6b342f0ab7cc39c2@mail.gmail.com>
	 <20071219133411.24d146e7@dhcp-252-066.norway.atmel.com>
X-Google-Sender-Auth: 038c214e437d6418
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Haavard,

> Hmm...perhaps we can eliminate the locking in the status handler
> too...? Does anyone see a problem with this patch?

I have not seen any problem so far, besides, I am very happy with a
lockless interrupt handling, because this helps reducing latencies.

Tested it on top of the other 5 patches, and everything still works,
also tested under stress conditions.

So:
Acked-by: Remy Bohmer <linux@bohmer.net>


Kind Regards,

Remy
