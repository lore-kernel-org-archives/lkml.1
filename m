Return-Path: <linux-kernel-owner+w=401wt.eu-S1753412Ab0AGUkL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab0AGUkL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:40:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025Ab0AGUkJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:40:09 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:37937 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752485Ab0AGUkH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:40:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=YcWHexn5RWLOenl8dxz/vyeIzH8oQkNCFjI1NGinCOrdMaNCJOUR10EhsG3+x3vzFn
         qi/nfmawB+S7Qu3IsbRNToln80iFyvPFGC4kvYjFI03xVZTyQAi9gUxU7ZdHhmN2rBWp
         oRmwar3rsxI63JMz0+VcQHqmwi6x9sDDLpGR8=
Message-ID: <4B4646B2.6050103@googlemail.com>
Date: Thu, 07 Jan 2010 21:40:18 +0100
From: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
References: <4B3BDB66.6000008@googlemail.com> <4B4632BF.4070806@pobox.com> <4B46453E.1060206@googlemail.com>
In-Reply-To: <4B46453E.1060206@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/10 21:34, René Bolldorf wrote:
> On 01/07/10 20:15, Jeff Garzik wrote:
>> I need a little bit more detail than an unqualified statement... Did
>> you audit all paths leading to this code point?
>
> Yes, and my two systems running fine with the patch, no oops or panic's.

Sry forgot that:
	/* initialize sense_buf with the error register,
	 * for the case where they are -not- overwritten
	 */
	sense_buf[0] = 0x70;
	sense_buf[2] = dfl_sense_key;

So i think memset() is not needed and works very well without it.
