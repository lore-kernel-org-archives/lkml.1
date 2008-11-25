Return-Path: <linux-kernel-owner+w=401wt.eu-S1752761AbYKYFRv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752761AbYKYFRv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2008 00:17:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751154AbYKYFRl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Nov 2008 00:17:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:53144 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751134AbYKYFRj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2008 00:17:39 -0500
Message-ID: <492B8996.2020302@zytor.com>
Date: Mon, 24 Nov 2008 21:13:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Hitoshi Mitake <h.mitake@gmail.com>
CC: "Luck, Tony" <tony.luck@intel.com>,
       Russell King <rmk+lkml@arm.linux.org.uk>,
       Ralf Baechle <ralf@linux-mips.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Doug Thompson <norsk5@yahoo.com>,
       "dougthompson@xmission.com" <dougthompson@xmission.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: [PATCH 1/1] edac x38: new MC driver module
References: <20081105222911.d76e7e1c.mitake@clustcom.com>	<413709.12821.qm@web50106.mail.re2.yahoo.com>	<20081106164641.ed369060.akpm@linux-foundation.org>	<20081107152830.a42766f3.mitake@clustcom.com>	<20081106223122.8a255211.akpm@linux-foundation.org>	<20081107153824.0ec934e6.mitake@clustcom.com>	<20081106231102.aab83cd4.akpm@linux-foundation.org>	<a6b9f31a0811090710y17e956bawf20675d6678b145e@mail.gmail.com>	<20081109112646.97c594b5.akpm@linux-foundation.org>	<20081118121620.GB8625@linux-mips.org>	<20081118123215.GB30509@flint.arm.linux.org.uk>	<20081121011941.26e05a25.h.mitake@gmail.com>	<4929ECB7.8080108@zytor.com>	<57C9024A16AD2D4C97DC78E552063EA35C517F42@orsmsx505.amr.corp.intel.com>	<492AEC40.5060009@zytor.com> <20081125115510.108fa886.h.mitake@gmail.com>
In-Reply-To: <20081125115510.108fa886.h.mitake@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hitoshi Mitake wrote:
> I think which need __ is variable type name, not each variable name.
> Name of each local variables can't effect namespace.

Wrong.  It affects the namespace in the sense that it can interfere with
user-created macros.  Again, this is only an issue for user space.

> And I found this comment in asm-generic/int-ll64.h,
> /*
>  * __xx is ok: it doesn't pollute the POSIX namespace. Use these in the
>  * header files exported to user space
>  */
> 
> According to your advice, I rewrote the patch, how is this?

Are you planning to add writeq() as well?

	-hpa
