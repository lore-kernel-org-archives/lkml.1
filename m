Return-Path: <linux-kernel-owner+w=401wt.eu-S1759465AbYHNSaM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759465AbYHNSaM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2008 14:30:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752166AbYHNS34
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Aug 2008 14:29:56 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:41251 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751373AbYHNS3z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2008 14:29:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=LlSvOVL/HHWnnbcv2PXoohQN4VNT9M6RIsj902Zr+zCOKIzWZvCI/6BLZmgdyKviUu
         AZzA/gmPLSKpDIhLNB1K3A5NBaiLpECD6Z4CiFuKdOfGE5uimeqOAgxdpmbGJr8/YwUu
         zayzb27XHj5BM/bYuaTr+IxVV0YJZWdYNm2Do=
Message-ID: <86802c440808141129t4399668bmc35def15e65fbe99@mail.gmail.com>
Date: Thu, 14 Aug 2008 11:29:53 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- revert for 2.6.26-rc1 failed
Cc: "Bill Fink" <billfink@mindspring.com>, linux-kernel@vger.kernel.org,
       "Ingo Molnar" <mingo@elte.hu>,
       "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
       "Peter Zijlstra" <peterz@infradead.org>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, netdev <netdev@vger.kernel.org>
In-Reply-To: <798351.12728.qm@web82105.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <798351.12728.qm@web82105.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I do not know how to bisect with your patch if I have a "bad" but no "good"
> to start with.  Can you explain how I should proceed when I _do_ get home?
> (I can just enabled those config options and try the patch again, but I am
> confused about the bisect you are asking me to perform.)
>
just like the old way doing git-bisect, but before compiling, apply
the batch, and before git-bisect good or bad, revert the patch.

YH
