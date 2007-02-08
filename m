Return-Path: <linux-kernel-owner+w=401wt.eu-S965731AbXBHRU0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965731AbXBHRU0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Feb 2007 12:20:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965732AbXBHRU0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 Feb 2007 12:20:26 -0500
Received: from ug-out-1314.google.com ([66.249.92.170]:39886 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965731AbXBHRUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Feb 2007 12:20:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=dTHmZTYyd4FzryWFLkbsGugvfYLg7uRqYzu9nqj+6neX1RxuplXMRiEX2dqffJvZ2oo0cpuc4Y8ashjnfXhj7LKj2Eu98zFWHqBj3GSR79uYt9cWVXVFVz0vZ9IlXzH8pvaHgKKEpP8f3usZMX+7oAz+tQ0VSvSSktoRdINWvmw=
Message-ID: <8bd0f97a0702080920o2dbdb9a9n45a8da2c8a2f38d8@mail.gmail.com>
Date: Thu, 8 Feb 2007 12:20:23 -0500
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: bryan.wu@analog.com
Subject: Re: [PATCH 2/3, try #3] Blackfin: serial driver for Blackfinarchitecture against Linux kernel 2.6.20
Cc: rmk+lkml@arm.linux.org.uk, alan@lxorguk.ukuu.org.uk, aubreylee@gmail.com,
       akpm@linux-foundation.org, rdunlap@xenotime.net,
       linux-kernel@vger.kernel.org
In-Reply-To: <1170845398.5399.36.camel@roc-desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1170845398.5399.36.camel@roc-desktop>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/7/07, Wu, Bryan <bryan.wu@analog.com> wrote:
> +       if (request_irq
> +           (uart->port.irq+1, bfin_serial_int, SA_INTERRUPT | SA_SHIRQ,

merely a cosmetic thing atm, but down the line we should convert these
SA_* flags to the new IRQF_* ones
-mike
