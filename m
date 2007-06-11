Return-Path: <linux-kernel-owner+w=401wt.eu-S1752822AbXFKNTl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752822AbXFKNTl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2007 09:19:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbXFKNTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Jun 2007 09:19:34 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:7232 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750774AbXFKNTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2007 09:19:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AB619YYn3C9VnETpo0UsnhMwg5PVTJH/HcaWLZk30RCThbghPouOBrBQPe8gZsbtGw3N92DPNrpUNHmfYhM2U1T0s3cya5taMmaC7WGYejAvuuJBLR/blLBidToilfQ27/qrmY0JFDxEzBedRpA3qS7ac0RYnmSfK8HX5s4qauI=
Message-ID: <19f34abd0706110619i7cf011d5x340b65dcf94f3365@mail.gmail.com>
Date: Mon, 11 Jun 2007 15:19:32 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: IRQ handler type mismatch for IRQ 7
Cc: linux-kernel@vger.kernel.org, "Thomas Gleixner" <tglx@linutronix.de>
In-Reply-To: <20070611131147.GA31307@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0706110607u6cf889dci9b8d48494cb40be0@mail.gmail.com>
	 <20070611131147.GA31307@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/07, Ingo Molnar <mingo@elte.hu> wrote:
> so both parport and serial is on the same IRQ: #7, but the parport one
> does not support shared interrupt lines (IRQF_SHARED). You can probably
> change the mapping in the BIOS (change the serial one to say IRQ#3 or
> IRQ#4). I suspect you dont have any real parallel port hardware
> attached? (and probably no serial port hardware either?) So you can
> safely ignore this.

Correct, there is neither serial nor parport hardware here. Thanks for
your help!

Vegard
