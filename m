Return-Path: <linux-kernel-owner+w=401wt.eu-S1760066AbXEaS5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760066AbXEaS5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 14:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757212AbXEaS5M
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 14:57:12 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:28878 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757216AbXEaS5L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 14:57:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=bj9Af7ssi2L6hkU84mOYrNHmVEg0BQoj+O7++qMg7Bk184QrIB7AnrbFiJrcxHvn8/WKDEyb15IP41E8gfcrm/flz/byJI1HH+K7ZeH5J6dfkVta0Cg+19Jk4yxmtWVNK/Za1nHIeD0IST44guo/NL0MxN5Ze7UGbsL4k1v2q2M=
Message-ID: <84144f020705311157n6bede2c7ga234d70823d5869f@mail.gmail.com>
Date: Thu, 31 May 2007 21:57:10 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: trenn@suse.de
Subject: Re: [PATCH] ACPI Debug - for test, devel and possibly even for production kernels
Cc: linux-acpi <linux-acpi@vger.kernel.org>, "Len Brown" <lenb@kernel.org>,
       "Andrew Morton" <akpm@osdl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <1180624839.10908.71.camel@queen.suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1180624839.10908.71.camel@queen.suse.de>
X-Google-Sender-Auth: 666d55c3394ac2c2
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/31/07, Thomas Renninger <trenn@suse.de> wrote:
> (This should efficiently be the same as the proposed big patch a year
> ago from Pekka Enberg, just a bit smaller and should make ACPICA and
> kernel/linux people happy:
> http://marc.info/?l=linux-kernel&m=113699535303722&w=2)

No, you're keeping these obfuscating macros around:

+#define return_VOID                     return
+#define return_ACPI_STATUS(s)           return(s)
+#define return_VALUE(s)                 return(s)
+#define return_UINT8(s)                 return(s)

Making the ACPI code look like regular Linux kernel code (or even
regular C for that matter) was the whole point of my patch. Your patch
doesn't change that.
