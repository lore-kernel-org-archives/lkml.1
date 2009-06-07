Return-Path: <linux-kernel-owner+w=401wt.eu-S1755303AbZFGTx5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755303AbZFGTx5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Jun 2009 15:53:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753848AbZFGTxr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Jun 2009 15:53:47 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42743 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753543AbZFGTxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Jun 2009 15:53:46 -0400
Date: Sun, 7 Jun 2009 20:54:01 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: lkml@morethan.org
Cc: Grozdan <neutrino8@gmail.com>, Robert Hancock <hancockrwd@gmail.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, tj@kernel.org
Subject: Re: Kernel 2.6.30rc7 limits IDE to UDMA33
Message-ID: <20090607205401.73556585@lxorguk.ukuu.org.uk>
In-Reply-To: <200906071346.28021.lkml@morethan.org>
References: <c5bd819b0906021525l13ee9282j1fb270e141985f66@mail.gmail.com>
	<4A2BF785.3020402@gmail.com>
	<c5bd819b0906071124j21270574h44db963bdc0b552d@mail.gmail.com>
	<200906071346.28021.lkml@morethan.org>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The article presumes the simple case of a single commit being the
> problem.  If the problem involves more than one. . .
> 
> Think of doing a binary search in a list of values with duplicate
> entries.  ;)

My first guess is its whatever starting putting devices in D3 rudely
around 2.6.28/29. Someone needs to pin that down anyway and fix it.
