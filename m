Return-Path: <linux-kernel-owner+w=401wt.eu-S1756739AbXKGM4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756739AbXKGM4T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2007 07:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753690AbXKGM4G
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Nov 2007 07:56:06 -0500
Received: from rv-out-0910.google.com ([209.85.198.188]:2069 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752495AbXKGM4E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2007 07:56:04 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=RLPHxuQbBMh4H9wGWhMSSjW/m6iEidaa/hnFZBq1CEiMouvfMAkCTgmoOwIv5VLGcbix8fzLCYKzOxfv94iaNZp33ek1LN9I6V/sRBCXjEXd27NAb7nBLxkavAMBaNfjNLB7LQgZJG8AeHs4JLdBeAWY+fG8xV8uN1YV33sELY4=
Message-ID: <4731B5DD.1060203@gmail.com>
Date: Wed, 07 Nov 2007 21:55:57 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: htejun@gmail.com, jeff@garzik.org, linux-kernel@vger.kernel.org
CC: IDE/ATA development list <linux-ide@vger.kernel.org>
Subject: Re: sata NCQ blacklist entry
References: <20071107111813.GA9064@dudweiler.stuttgart.redhat.com>
In-Reply-To: <20071107111813.GA9064@dudweiler.stuttgart.redhat.com>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Florian La Roche wrote:
> Hello all,
> 
> I've taking email addresses from the last NCQ blacklist changes going
> into the kernel.
> This Fujitsu drive also gives me spurious command completions. Detailed
> output also available at https://bugzilla.redhat.com/show_bug.cgi?id=366181.
> 
> Let me know if you need more info or anything else.
> 
> --- drivers/ata/libata-core.c
> +++ drivers/ata/libata-core.c
> @@ -4222,6 +4222,7 @@
>  	{ "WDC WD740ADFD-00NLR1", NULL,		ATA_HORKAGE_NONCQ, },
>  	{ "WDC WD3200AAJS-00RYA0", "12.01B01",	ATA_HORKAGE_NONCQ, },
>  	{ "FUJITSU MHV2080BH",	"00840028",	ATA_HORKAGE_NONCQ, },
> +	{ "FUJITSU MHW2160BJ G2",       NULL,           ATA_HORKAGE_NONCQ },
>  	{ "ST9120822AS",	"3.CLF",	ATA_HORKAGE_NONCQ, },
>  	{ "ST9160821AS",	"3.CLF",	ATA_HORKAGE_NONCQ, },
>  	{ "ST9160821AS",	"3.ALD",	ATA_HORKAGE_NONCQ, },

Thanks.  We're currently trying to find out what's actually going on
with all these drives.  At first, drives which got blacklisted aren't
many and made sense (had other problems with NCQ, etc..) but with new
generation drives from many vendors showing the same symptom, we aren't
too sure now.

I'll keep your email in my todo list and add the drive to the blacklist
once the problem is verified.

Thanks.

-- 
tejun
