Return-Path: <linux-kernel-owner+w=401wt.eu-S1752767AbZAKHfW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752767AbZAKHfW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 02:35:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751176AbZAKHfE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 02:35:04 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:59590
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751065AbZAKHfD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 02:35:03 -0500
Date: Sat, 10 Jan 2009 23:35:03 -0800 (PST)
Message-Id: <20090110.233503.222465267.davem@davemloft.net>
To: paulus@samba.org
Cc: gorcunov@gmail.com, akpm@linux-foundation.org, jchapman@katalix.com,
       linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] net: ppp_generic - fix broken userspace
From: David Miller <davem@davemloft.net>
In-Reply-To: <18793.15831.279207.252421@cargo.ozlabs.ibm.com>
References: <20090110202802.GF29349@localhost>
	<20090110203112.GG29349@localhost>
	<18793.15831.279207.252421@cargo.ozlabs.ibm.com>
X-Mailer: Mew version 6.1 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Mackerras <paulus@samba.org>
Date: Sun, 11 Jan 2009 11:31:19 +1100

> Judging by the subject, it sounds like I'm not going to like it...

PPP was converted to use IDR instead of PPP's duplicate
implementation.

A bug was introduced in that conversion, and that bug is being fixed
here.

What is not to like? :-)
