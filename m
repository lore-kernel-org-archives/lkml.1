Return-Path: <linux-kernel-owner+w=401wt.eu-S1753269AbYJVMqz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753269AbYJVMqz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 08:46:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751771AbYJVMqq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 08:46:46 -0400
Received: from vsmtp04.dti.ne.jp ([202.216.231.139]:62340 "EHLO
	vsmtp04.dti.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813AbYJVMqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 08:46:46 -0400
From: hooanon05@yahoo.co.jp
Subject: Re: __vm_enough_memory(), OVERCOMMIT_NEVER, current->mm, kernel thread 
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20081022130926.44540b03@lxorguk.ukuu.org.uk>
References: <7123.1224602071@jrobl> <20081021164619.341f01d9@lxorguk.ukuu.org.uk> <6775.1224630654@jrobl> <20081022092736.2a0795d1@lxorguk.ukuu.org.uk> <6689.1224674779@jrobl> <20081022130926.44540b03@lxorguk.ukuu.org.uk>
Date: Wed, 22 Oct 2008 21:46:32 +0900
Message-ID: <6920.1224679592@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Alan Cox:
> This is the patch I propose:
	:::
> We could simply check for NULL and skip the modifier but we've caught other
> real bugs in the past from mm being NULL here - cases where we did need a
> valid mm set up (eg the exec bug about a year ago).

OK.
I didn't know there was an actual bug but now I understand why you want
to insert WARN_ON().

I have nothing to say about your patch.


Thank you
Junjiro R. Okajima
