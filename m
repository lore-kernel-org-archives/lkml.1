Return-Path: <linux-kernel-owner+w=401wt.eu-S1754734AbYFROTs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734AbYFROTs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2008 10:19:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750744AbYFROTk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Jun 2008 10:19:40 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:53455 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750737AbYFROTj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2008 10:19:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=WeDAPUEch0OZfU6xgTFPmdrR8h/So5KV3tEskryvoEtp1e1IhjmRT2tiqPxoEluUVS
         k9GHpD5OSUdlkdyg7xiEFirM7xEtSiGa8MTXEaU4xjl6uHsrauyZKKAjZmzXzC/8ouaF
         jSRPep+s1egaq7j1urTAGbDHmJ/CmtWF7mECE=
Message-ID: <4d8e3fd30806180719j718a3b1ds461495c4d3de8236@mail.gmail.com>
Date: Wed, 18 Jun 2008 16:19:38 +0200
From: "Paolo Ciarrocchi" <paolo.ciarrocchi@gmail.com>
To: "Dmitri Vorobiev" <dmitri.vorobiev@movial.fi>
Subject: Re: [PATCH] x86: coding style fixes to arch/x86/math-emu/reg_constant
Cc: "Ingo Molnar" <mingo@elte.hu>, tglx <tglx@linutronix.de>,
       hpa <hpa@zytor.com>, "Linux Kernel" <linux-kernel@vger.kernel.org>,
       "Andy Whitcroft" <apw@shadowen.org>
In-Reply-To: <48590926.5060009@movial.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080614204452.25378bd0@paolo-desktop>
	 <48590926.5060009@movial.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2008 at 3:09 PM, Dmitri Vorobiev
<dmitri.vorobiev@movial.fi> wrote:
> Paolo Ciarrocchi wrote:
>>
>> -static void fld_const(FPU_REG const *c, int adj, u_char tag)
>> +static void fld_const(FPU_REG const * c, int adj, u_char tag)
> ________________________________________^
>
> The above does not seem to me like a big improvement in code quality. A
> false positive from checkpatch.pl?

Yes, I think you are right.
Andy CC'ed so that he can have a look at that.

Thanks.

regards,
-- 
Paolo
http://paolo.ciarrocchi.googlepages.com/
