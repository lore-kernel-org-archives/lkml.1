Return-Path: <linux-kernel-owner+w=401wt.eu-S1756573Ab0ASKMx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756573Ab0ASKMx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jan 2010 05:12:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752932Ab0ASKMv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Jan 2010 05:12:51 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60684
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755448Ab0ASKMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jan 2010 05:12:51 -0500
Date: Tue, 19 Jan 2010 02:13:01 -0800 (PST)
Message-Id: <20100119.021301.228036686.davem@davemloft.net>
To: lsorense@csclub.uwaterloo.ca
Cc: linux-kernel@vger.kernel.org, gabriele.paoloni@intel.com,
       netdev@vger.kernel.org
Subject: Re: ppp_generic.c severly whitespace damanged by
 9c705260feea6ae329bc6b6d5f6d2ef0227eda0a
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100118225955.GA24307@caffeine.csclub.uwaterloo.ca>
References: <20100118225955.GA24307@caffeine.csclub.uwaterloo.ca>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: lsorense@csclub.uwaterloo.ca (Lennart Sorensen)
Date: Mon, 18 Jan 2010 17:59:55 -0500

> I was just looking at ppp_generic, and noticed that it fairly recently
> (as in the last year) got rather mangled with many spaces turned into tabs
> in places they very much shouldn't have been.  I tracked it down to commit
> 9c705260feea6ae329bc6b6d5f6d2ef0227eda0a (ppp: ppp_mp_explode() redesign).
> 
> I am amazed if that patch passed the patch checking script.  I have no
> idea what kind of weird editor setting did this, but it has to have been a
> weird editor setting or a very unfortunate search and replace gone wrong.
> I only found it trying to apply a patch I was playing with and wondering
> why it wouldn't apply.  Then I found there were tabs in the middle of
> comments that used to be spaces.
> 
> Well here is a patch that should fix it up as far as I can tell.
> 
> Purely whitespace repair.  No actual code changes.
> 
> Signed-off-by: Len Sorensen <lsorense@csclub.uwaterloo.ca>

I'm probably responsible for not catching this sorry.

Applied to net-next-2.6, thanks.
