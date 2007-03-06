Return-Path: <linux-kernel-owner+w=401wt.eu-S933348AbXCFADG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933348AbXCFADG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2007 19:03:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933344AbXCFADG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Mar 2007 19:03:06 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:38643
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933348AbXCFADF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2007 19:03:05 -0500
Date: Mon, 05 Mar 2007 16:03:03 -0800 (PST)
Message-Id: <20070305.160303.59493440.davem@davemloft.net>
To: dmlb2000@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: PAGE_SIZE Availability Inconsistency
From: David Miller <davem@davemloft.net>
In-Reply-To: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com>
References: <9c21eeae0703051555x1884fd7cse7968a71ec04eb27@mail.gmail.com>
X-Mailer: Mew version 5.1.52 on Emacs 21.4 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David Brown" <dmlb2000@gmail.com>
Date: Mon, 5 Mar 2007 15:55:06 -0800

> I'm kinda wondering how I'm supposed to write portable user-space code
> if I want to use the PAGE_SIZE define on different architectures.

Call getpagesize().
