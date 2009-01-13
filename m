Return-Path: <linux-kernel-owner+w=401wt.eu-S1758113AbZAMXsF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758113AbZAMXsF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jan 2009 18:48:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759257AbZAMXro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Jan 2009 18:47:44 -0500
Received: from mx1.redhat.com ([66.187.233.31]:57956 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759052AbZAMXrn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jan 2009 18:47:43 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: mtk.manpages@gmail.com, mtk.manpages@googlemail.com,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
       drepper@redhat.com, vegard.nossum@gmail.com, linux-man@vger.kernel.org,
       stable@kernel.org
Subject: Re: [PATCH] sys_waitid: return -EFAULT for NULL
In-Reply-To: Andrew Morton's message of  Tuesday, 13 January 2009 15:24:57 -0800 <20090113152457.0d7685ad.akpm@linux-foundation.org>
X-Fcc: ~/Mail/linus
References: <cfd18e0f0901131436ud2cf61bkf0e6b00f4b765bb5@mail.gmail.com>
	<cfd18e0f0901131438n232ba114n27ea2d7964d071de@mail.gmail.com>
	<20090113224759.7DFB7FC3DD@magilla.sf.frob.com>
	<20090113224941.36F19FC3DD@magilla.sf.frob.com>
	<cfd18e0f0901131514i2f7be7f1t2c6275c26dbb6874@mail.gmail.com>
	<20090113152457.0d7685ad.akpm@linux-foundation.org>
X-Zippy-Says: This PORCUPINE knows his ZIPCODE..  And he has ``VISA''!!
Message-Id: <20090113234716.765A8FC3DD@magilla.sf.frob.com>
Date: Tue, 13 Jan 2009 15:47:16 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Well yes.  waitid() has been in there since 2.6.9.  I assume that it
> has had this wait4-emulation mode for that amount of time as well?

Correct.

> Well, we might get away with it.  But formally speaking, we should live
> with our Linux-specific screwup.

I agree with both of you and I don't care which we do.


Thanks,
Roland
