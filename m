Return-Path: <linux-kernel-owner+w=401wt.eu-S964864AbXFFCvU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964864AbXFFCvU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2007 22:51:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751161AbXFFCvN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jun 2007 22:51:13 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:25006 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751158AbXFFCvM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2007 22:51:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=SktBu2khqcdSC/rWnGiPqs7lXAMaagPsKtQEZot3BxLHiBWe++9yNK23qOxyZ81Qdg9Dmka6WnZ6FoAGBe0L42j9Wnne5ZI6WE8KBaB74BC00R/prx4DFiR2xi6cuz+Xf2ym0Y/09dQGYdVh08O2NWuLB3y1HATWQNJOHzw5YH4=
Message-ID: <a8e1da0706051951sacf5785wca1464c689891854@mail.gmail.com>
Date: Wed, 6 Jun 2007 02:51:11 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [BUG] 2.6.22-rc3-mm1 remove bluetooth usb adapter caused kmalloc bug
Cc: "clameter@sgi.com" <clameter@sgi.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Marcel Holtmann" <marcel@holtmann.org>,
       "Jiri Kosina" <jkosina@suse.cz>
In-Reply-To: <20070605194236.03e07a1f.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0706051856g242dad96rf4286283192b06c4@mail.gmail.com>
	 <20070605194236.03e07a1f.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,
> Are you able to reproduce this in 2.6.22-rc4?
 The kmalloc in dmesg is in skbuff.c:pskb_expand_head, I will try
2.6.22-rc4 ASAP.
