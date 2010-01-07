Return-Path: <linux-kernel-owner+w=401wt.eu-S1753136Ab0AGUd6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753136Ab0AGUd6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jan 2010 15:33:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752823Ab0AGUd4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Jan 2010 15:33:56 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:49422 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752625Ab0AGUdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jan 2010 15:33:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bqUofU6XyJsLAjXCtl/mD27dwZABsdYlRfS6TwB/bdfh2kGMxozDg78C6ga1C8xivd
         yYg0wA8HR68M/IkjuS4v+NSV+sqMIv+mR5i9LjhO2Schm5LR0bqGsDp4oEPpbnt3CBwY
         h6tQwl97JaOZnTW9ijP/r4cj8JJSRU1wyxeP0=
Message-ID: <4B46453E.1060206@googlemail.com>
Date: Thu, 07 Jan 2010 21:34:06 +0100
From: =?ISO-8859-1?Q?Ren=E9_Bolldorf?= <xsecute@googlemail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Jeff Garzik <jgarzik@pobox.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
       linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH]drivers/ata/libata-eh.c:1509 unneeded memset()
References: <4B3BDB66.6000008@googlemail.com> <4B4632BF.4070806@pobox.com>
In-Reply-To: <4B4632BF.4070806@pobox.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/10 20:15, Jeff Garzik wrote:
> I need a little bit more detail than an unqualified statement...  Did
> you audit all paths leading to this code point?

Yes, and my two systems running fine with the patch, no oops or panic's.
