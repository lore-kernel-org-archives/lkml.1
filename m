Return-Path: <linux-kernel-owner+w=401wt.eu-S1756554AbZLIDqJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554AbZLIDqJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Dec 2009 22:46:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756533AbZLIDqG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Dec 2009 22:46:06 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:33843 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbZLIDqE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Dec 2009 22:46:04 -0500
Date: Wed, 9 Dec 2009 12:44:54 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Nicolas Palix <npalix@diku.dk>
Cc: kernel-janitors@vger.kernel.org, Stuart Menefy <stuart.menefy@st.com>,
       linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/sh: Replace an explicit computation by the use of the container_of macro
Message-ID: <20091209034453.GB28280@linux-sh.org>
References: <200912071046.27330.npalix@diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200912071046.27330.npalix@diku.dk>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 07, 2009 at 10:46:26AM +0100, Nicolas Palix wrote:
> From 945e75c0e3202ab4cd0b8f185ea4be5609806edb Mon Sep 17 00:00:00 2001
> From: Nicolas Palix <npalix@diku.dk>
> Date: Mon, 7 Dec 2009 10:38:55 +0100
> 
> The macro container_of from kernel.h performs the same
> pointer arithmetic operation.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> type T;
> expression mptr;
> expression member;
> @@
> 
> - (void *)((char *)mptr - offsetof(T, member))
> + container_of(mptr, T, member)
> // </smpl>
> 
> Signed-off-by: Nicolas Palix <npalix@diku.dk>

Applied, thanks.
