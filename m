Return-Path: <linux-kernel-owner+w=401wt.eu-S1755371AbZLCRjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755371AbZLCRjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Dec 2009 12:39:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753419AbZLCRjo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 Dec 2009 12:39:44 -0500
Received: from mail-gx0-f226.google.com ([209.85.217.226]:33306 "EHLO
	mail-gx0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751429AbZLCRjn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Dec 2009 12:39:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LM2O6NrxMnPrSRwM7a31+oHO8VE613OJyApJmW1auJt/jw3338iYLvuPjB9ky9tzj/
         /E8Qf72CRSVBUh66pMsOSSb+8v1QuttJ5se2SmP1w+VDd/z8VqRXRVr+pVDm/XhX6J7N
         WNuE6mJQHKhfjzYGsuta7gFSOxjzbGxYVaark=
Message-ID: <4B17F7E4.9040302@garzik.org>
Date: Thu, 03 Dec 2009 12:39:48 -0500
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091014 Fedora/3.0-2.8.b4.fc11 Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/86] PATA fixes
References: <20091125170218.5446.13513.sendpatchset@localhost>	<4B1771CD.3090409@garzik.org> <20091203165947.13841802@lxorguk.ukuu.org.uk>
In-Reply-To: <20091203165947.13841802@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2009 11:59 AM, Alan Cox wrote:
>> The merge window is upon us, which by strict rules means that anything
>> not already in libata-dev.git#upstream needs to wait until 2.6.34.
>
> Not quite yet - Linus hasn't said "go"

He rarely if ever says "go."  The kernel X is released, and people send 
pull requests to Linus for X+1.  He typically merges immediately, but 
does not push out the first set of merges for a few days.

The stuff pushed to Linus for kernel X+1 should have already been living 
in linux-next (libata-dev.git#NEXT, to us).


> The bits that probably should be delayed a bit more (if any) IMHO are the
> 32bit enables for hardware that doesn't use 32bit by default on the
> drivers/ide stack, and tweaks for obscure old hardware that won't get
> much testing.

Agreed mostly...  I still want to push fixes even if for obscure hardware.

	Jeff



