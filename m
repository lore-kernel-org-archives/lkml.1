Return-Path: <linux-kernel-owner+w=401wt.eu-S1762346AbYEUWYX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762346AbYEUWYX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 18:24:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753433AbYEUWYQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 18:24:16 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:20329 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877AbYEUWYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 18:24:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=AJZLVY7waNLWOPCN0virFoNC+cKZgle9mQyVF0fEgTCKMY5gdDooFP+OEUrDvS8ac6wKq6O3chudAshDmclXAI920yStDLem4uF9F4yD7Mglb6eckyofAOncwuRAyCb87+/gaCQS1R83H6P73MxR4um9nV4WyCI6vR4WnwjEJuA=
Message-ID: <9a8748490805211524r10bac2c8ke6e3766c0b5152f1@mail.gmail.com>
Date: Thu, 22 May 2008 00:24:03 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Johannes Weiner" <hannes@saeurebad.de>
Subject: Re: [patch] kmalloc returns (void*), don't do type conversions
Cc: "Philipp Marek" <philipp@marek.priv.at>, linux-kernel@vger.kernel.org,
       linux-trivial@kernel.org
In-Reply-To: <877idn4dk1.fsf@saeurebad.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200805212113.51936@marek.priv.at> <877idn4dk1.fsf@saeurebad.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/5/21 Johannes Weiner <hannes@saeurebad.de>:
> Hi Phillip,
>
> Philipp Marek <philipp@marek.priv.at> writes:
>
>> I tried a "make allyesconfig", but that gave some compile errors
>> that don't seem related to my changes:
>>       drivers/block/cciss_scsi.c:75: error: 'MAX_CTLR' undeclared here (not in a function)
>>       drivers/block/cciss_scsi.c:76: error: field name not in record or union initializer
>
> You probably should write another email regarding this.
>
I agree, keep things seperate. One mail with patch to fix casts,
another to report build breakage.

>> Please tell me if that's the correct approach; I'm sorry that I
>> couldn't find out who the correct maintainer for these changes is.
>
> Added the trivial tree maintainer to CC.  Jesper?
>
Thank you, I'll keep an eye on this patch.

Philipp: Johannes makes some good points, please address his comments
and re-submit the patch with trivial@kernel.org on Cc:  if it draws no
negative comments it looks good to me to add to the trivial tree.

-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please http://www.expita.com/nomime.html
