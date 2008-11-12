Return-Path: <linux-kernel-owner+w=401wt.eu-S1752174AbYKLRQG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752174AbYKLRQG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 12:16:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751476AbYKLRPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 12:15:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43689 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbYKLRPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 12:15:50 -0500
Message-ID: <491B0E6F.2010301@zytor.com>
Date: Wed, 12 Nov 2008 09:12:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Ingo Molnar <mingo@elte.hu>, Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: ia32_signal: remove unnecessary padding
References: <491A48E9.8020909@ct.jp.nec.com>	<491A496B.5010505@ct.jp.nec.com>	<20081112112937.GA6372@elte.hu> <18714.52512.213371.33245@harpo.it.uu.se>
In-Reply-To: <18714.52512.213371.33245@harpo.it.uu.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
> It does cause each signal delivery to leak 2 uninitialised
> kernel bytes to the end of retcode[], which seems unnecessary.

Not just unnecessary, it is a huge no-no for security.

NAK on this.

	-hpa
