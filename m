Return-Path: <linux-kernel-owner+w=401wt.eu-S1765901AbYCEXNp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765901AbYCEXNp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 18:13:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933239AbYCEXKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 18:10:17 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33876
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S933198AbYCEXKN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 18:10:13 -0500
Date: Wed, 05 Mar 2008 15:10:12 -0800 (PST)
Message-Id: <20080305.151012.07703232.davem@davemloft.net>
To: matz@suse.de
Cc: hpa@zytor.com, richard.guenther@gmail.com, Joe.Buck@synopsys.com,
       hubicka@ucw.cz, aurelien@aurel32.net, linux-kernel@vger.kernel.org,
       gcc@gcc.gnu.org
Subject: Re: RELEASE BLOCKER: Linux doesn't follow x86/x86-64 ABI wrt
 direction flag
From: David Miller <davem@davemloft.net>
In-Reply-To: <Pine.LNX.4.64.0803060006520.20583@wotan.suse.de>
References: <Pine.LNX.4.64.0803052341330.20583@wotan.suse.de>
	<47CF25A5.5060709@zytor.com>
	<Pine.LNX.4.64.0803060006520.20583@wotan.suse.de>
X-Mailer: Mew version 5.2 on Emacs 22.1 / Mule 5.0 (SAKAKI)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Matz <matz@suse.de>
Date: Thu, 6 Mar 2008 00:07:39 +0100 (CET)

> The fix lies in the kernel, the work-around in gcc.

This depends upon how you interpret this ABI situation.

There is at least some agreement that how things have
actually been implemented by these kernels for more
than 15 years trumps whatever a paper standard states.
