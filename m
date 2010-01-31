Return-Path: <linux-kernel-owner+w=401wt.eu-S1753745Ab0AaNbq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753745Ab0AaNbq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Jan 2010 08:31:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753665Ab0AaNbn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 31 Jan 2010 08:31:43 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:7164 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752955Ab0AaNbl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Jan 2010 08:31:41 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,5877"; a="33165558"
Subject: Re: [PATCH] staging/dream: add missing include files/fix
 compilation
From: Daniel Walker <dwalker@codeaurora.org>
To: Pavel Machek <pavel@ucw.cz>
Cc: Greg KH <greg@kroah.com>, Arve Hj?nnev?g <arve@android.com>,
       kernel list <linux-kernel@vger.kernel.org>,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Brian Swetland <swetland@google.com>,
       Iliyan Malchev <malchev@google.com>, linux-arm-msm@vger.kernel.org
In-Reply-To: <20100131084421.GG2238@elf.ucw.cz>
References: <20091225205917.GA25761@elf.ucw.cz>
	 <20100115002419.GA25643@kroah.com> <20100119054516.GB22153@elf.ucw.cz>
	 <1263914079.1951.43.camel@m0nster>  <20100131084421.GG2238@elf.ucw.cz>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 31 Jan 2010 05:31:30 -0800
Message-ID: <1264944690.2059.2.camel@m0nster>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-01-31 at 09:44 +0100, Pavel Machek wrote:

> arch/arm/mach-msm/rpc_hsusb.c: In function 'msm_chg_rpc_connect':
> arch/arm/mach-msm/rpc_hsusb.c:156: error: implicit declaration of
> function 'machine_is_msm7201a_surf'
> arch/arm/mach-msm/rpc_hsusb.c:156: error: implicit declaration of
> function 'machine_is_msm7x27_surf'
> arch/arm/mach-msm/rpc_hsusb.c:157: error: implicit declaration of
> function 'machine_is_qsd8x50_surf'
> make[1]: *** [arch/arm/mach-msm/rpc_hsusb.o] Error 1
> make: *** [arch/arm/mach-msm] Error 2
> 
> (and similar error further down). This fixes it, but you probably want
> to add machine_is_* to your git. (Aha, is that what you meant by
> "machine types"?

Yeah, those machines aren't registered so the inlines don't get
generated .. 

> With this patch it compiles.

I need to actually register those machine types, So I can't remove them.
They are valid boards.

Daniel

