Return-Path: <linux-kernel-owner+w=401wt.eu-S1754505AbYKMRjg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754505AbYKMRjg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2008 12:39:36 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751717AbYKMRj1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Nov 2008 12:39:27 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41480 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268AbYKMRj1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2008 12:39:27 -0500
Message-ID: <491C662F.9020308@zytor.com>
Date: Thu, 13 Nov 2008 09:38:55 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mikael Pettersson <mikpe@it.uu.se>
CC: Hiroshi Shimamoto <h-shimamoto@ct.jp.nec.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86: ia32_signal: remove unnecessary padding
References: <491A48E9.8020909@ct.jp.nec.com>	<491A496B.5010505@ct.jp.nec.com>	<20081112112937.GA6372@elte.hu>	<18714.52512.213371.33245@harpo.it.uu.se>	<491B0E6F.2010301@zytor.com>	<491B1A40.5020900@ct.jp.nec.com>	<491B1C7C.5000906@zytor.com> <18715.59672.641830.690773@harpo.it.uu.se>
In-Reply-To: <18715.59672.641830.690773@harpo.it.uu.se>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mikael Pettersson wrote:
>  > 
>  > Ah, nevermind, then.  Then it fine, obviously.
> 
> Agreed. I wonder how on earth those templates ended
> up as 10 bytes large when retcode[] always has been
> 8 bytes.

Probably someone added something and didn't adjust the padding.

	-hpa
