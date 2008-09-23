Return-Path: <linux-kernel-owner+w=401wt.eu-S1755712AbYIWUrX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755712AbYIWUrX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2008 16:47:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755484AbYIWUqr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Sep 2008 16:46:47 -0400
Received: from mail-gx0-f16.google.com ([209.85.217.16]:36190 "EHLO
	mail-gx0-f16.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754854AbYIWUqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2008 16:46:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Q5RFEVxT8nGqQUOL+C7+ArzeSZJEhIu7MBsXLROECpMgZYGRZ1wHWir5WEMsxC1V71
         pNK2T2P7mfZ0rUHQFJ3BwdUmebo26Yvlua5B/BhPbpqMFbcZ7EnmE1Zvlx1FDf+JdpqV
         UIvJjtB6gRPrOnwa4vNV08ZDyKvfPWdfsLNHc=
Message-ID: <e9c3a7c20809231346q264cc764s703af8b9e386e445@mail.gmail.com>
Date: Tue, 23 Sep 2008 13:46:44 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Timur Tabi" <timur@freescale.com>
Subject: Re: [PATCH] fsl-dma: allow Freescale Elo DMA driver to be compiled as a module
Cc: linux-kernel@vger.kernel.org, "Andrew Morton" <akpm@linux-foundation.org>,
       leoli@freescale.com
In-Reply-To: <48D8074F.9030106@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221755059-27204-1-git-send-email-timur@freescale.com>
	 <e9c3a7c20809201432y31da1e00mf3a20c60b918fab1@mail.gmail.com>
	 <48D8074F.9030106@freescale.com>
X-Google-Sender-Auth: e2f544d126959c19
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2008 at 1:59 PM, Timur Tabi <timur@freescale.com> wrote:
> Dan Williams wrote:
>
>> The last three hunks should be broken out into a separate 'fix' patch
>> with its own changelog.
>
> Can you be more specific?  I can see how "return 0" -> "return -ENOMEM" could be
> separated out, but the Kconfig hunk is integral to the patch, and the "if
> (fsl_chan->desc_pool) return 1;" is needed to prevent a memory leak if the
> module is unloaded.
>

Sorry, I miscounted.  I was indeed referring to the just the "return 0
--> return -ENOMEM" fix.

--
Dan
