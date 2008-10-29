Return-Path: <linux-kernel-owner+w=401wt.eu-S1754768AbYJ2UwT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754768AbYJ2UwT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Oct 2008 16:52:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753165AbYJ2UwI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 29 Oct 2008 16:52:08 -0400
Received: from ti-out-0910.google.com ([209.85.142.191]:55798 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763AbYJ2UwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Oct 2008 16:52:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=SiiL62wkqVexy4nbNsiPouGNgCR8hVTxiFembqawex6VZjyfIXVcP3x96KC/8oHT9/
         W7a1ZwOPbCHZFDVsQWD/FdGhg8NmcOGkT0mdkYRKSw0whulQ0sU/u9uaw96RyMMAE1SU
         P9F5uzXB72UDhzMlRPsy4Omy9vxq3XAIhVlfg=
Message-ID: <7a9b5c320810291352k5db86a4eg4e03fb09317de459@mail.gmail.com>
Date: Thu, 30 Oct 2008 09:52:04 +1300
From: "Phillip O'Donnell" <phillip.odonnell@gmail.com>
To: "Ric Wheeler" <rwheeler@redhat.com>
Subject: Re: sata errors with Seagate 1.5TB on AMD 780G/SB700 motherboard
Cc: "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Oskar Liljeblad" <oskar@osk.mine.nu>,
       "Robert Hancock" <hancockr@shaw.ca>, linux-kernel@vger.kernel.org
In-Reply-To: <4908C62E.5070307@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fa.01zEaARwrup2dCOTuHTYxzuS9BI@ifi.uio.no>
	 <49079E09.20703@shaw.ca> <20081029185856.GA8152@osk.mine.nu>
	 <20081029201724.0a7d736e@lxorguk.ukuu.org.uk>
	 <4908C62E.5070307@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ric,

Not too sure about that - I run with XFS, which announces that it
disables the barriers on my devices (I use LVM on top of them) but
still get the same issue... Unless I've misunderstood your comment?

Cheers,
Phillip

> I suspect that the drive is simply choking on the barrier related cache
> flushing that we do - that seemed to be the MacOS error as well. The windows
> comment suggested that windows had an hba/driver bug (most likely unrelated
> to this).
>
> If you want to avoid the issue until they fix the drive, you could run fast
> and dangerous (mount without barriers on) or slow and safe (disable the
> write cache).
