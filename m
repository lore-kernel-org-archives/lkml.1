Return-Path: <linux-kernel-owner+w=401wt.eu-S1761626AbZLKXPA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761626AbZLKXPA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Dec 2009 18:15:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759162AbZLKXO4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Dec 2009 18:14:56 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:58929
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750779AbZLKXO4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Dec 2009 18:14:56 -0500
Date: Fri, 11 Dec 2009 15:15:02 -0800 (PST)
Message-Id: <20091211.151502.188418417.davem@davemloft.net>
To: vapier@gentoo.org
Cc: netdev@vger.kernel.org, nico@fluxnic.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] smc91x: fix unused flags warnings on UP systems
From: David Miller <davem@davemloft.net>
In-Reply-To: <1260366004-27366-1-git-send-email-vapier@gentoo.org>
References: <1260366004-27366-1-git-send-email-vapier@gentoo.org>
X-Mailer: Mew version 6.2 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mike Frysinger <vapier@gentoo.org>
Date: Wed,  9 Dec 2009 08:40:04 -0500

> Local flags variables will be declared whenever these functions get used,
> but obviously on UP systems the flags parameter won't be touched.  So add
> some dummy ops that get optimized away anyways to satisfy gcc's warnings.
> 
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>

Applied, although I thought we had a standard macro to handle this
kind of case.

In any case, for future reference, the usual way to handle this is
usually "(void) var;"
