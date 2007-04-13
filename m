Return-Path: <linux-kernel-owner+w=401wt.eu-S932247AbXDMTSe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247AbXDMTSe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2007 15:18:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932263AbXDMTSe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Apr 2007 15:18:34 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:31436 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932247AbXDMTSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2007 15:18:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=BhXXDIoUa2loMxTHJD4mN43WoVsn66UBptIIEf23I/S6LPFgAcaoKS3l519lZcJLBrkZZGE1CkwbGJza3W0OWLtaJrD0dfbDXpyIjg6XJbJ+SkMYajnj/Mnl51tQio8EN6gQdenJZr71PrbFoIHmOPDd9sv+vamU/POuhno/lps=
Message-ID: <d120d5000704131218x4e0485d7vbc290d1821a65ca3@mail.gmail.com>
Date: Fri, 13 Apr 2007 15:18:32 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Dave Jones" <davej@redhat.com>
Subject: Re: i8042 lockdep false positive.
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070413191415.GA27682@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070413191415.GA27682@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dave,

On 4/13/07, Dave Jones <davej@redhat.com> wrote:
> I just had a user file the report below, which iirc, was deemed a false
> positive.  Didn't we add something to the code so that lockdep would
> ignore what this was doing ?  Did we regress?
>

For some reasn lockdep annotations cease to work when you reload
psmouse module. I did not have time to look further.

-- 
Dmitry
