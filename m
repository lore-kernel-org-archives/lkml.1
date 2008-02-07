Return-Path: <linux-kernel-owner+w=401wt.eu-S1761378AbYBGDZ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761378AbYBGDZ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 22:25:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759191AbYBGDZs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 22:25:48 -0500
Received: from smtp106.sbc.mail.re2.yahoo.com ([68.142.229.99]:24867 "HELO
	smtp106.sbc.mail.re2.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1759162AbYBGDZr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 22:25:47 -0500
X-YMail-OSG: Ge.mUlEVM1kAc9Xqfo1tA1TcGzTKLU3qgNd6Fbwz1.ZlaSBcalQSDU1hpzMEbAVKnJIZ9_DWsM5gAeBPnXW8PNOiI9mTrlsZBkyOPwIllvfoNgEGA54FseHjdaw3_1mIvlDXzf6A3ZFXc4ITrpk6JXjb
X-Yahoo-Newman-Property: ymail-3
Date: Wed, 6 Feb 2008 21:23:31 -0600
From: serge@hallyn.com
To: Jeff Chua <jeff.chua.linux@gmail.com>
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
       lkml <linux-kernel@vger.kernel.org>, Andrew Morgan <morgan@kernel.org>
Subject: Re: where is the capset kernel module?
Message-ID: <20080207032331.GA25762@vino.hallyn.com>
References: <b6a2187b0802060013i2969a577x921be4d1a1202248@mail.gmail.com> <b6a2187b0802060243u3d8187b8v878dddf9eb4d3cb0@mail.gmail.com> <Pine.LNX.4.64.0802061225240.23855@fbirervta.pbzchgretzou.qr> <b6a2187b0802060356r19e59e67lfa572939545872e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b6a2187b0802060356r19e59e67lfa572939545872e@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Jeff Chua (jeff.chua.linux@gmail.com):
> On Feb 6, 2008 7:40 PM, Jan Engelhardt <jengelh@computergmbh.de> wrote:
> 
> > >warning: `named' uses 32-bit capabilities (legacy support in use)
> > Yes it is a really interesting case I have seen before,
> > but did not bother to investigate.
> > CONFIG_SECURITY=y
> > CONFIG_SECURITY_CAPABILITIES=m or y
> 
> Tried, but didn't help.
> 
> Menuconfig can't select these as modules. So may be that's they need
> to be make modular.
> 
>      [*] Enable different security models
>      [*]   Socket and Networking Security Hooks (NEW)
>      [*]   Default Linux Capabilities (NEW)
>      [*] File POSIX Capabilities (EXPERIMENTAL)
>      [ ] Root Plug Support (NEW)

Odd, I thought the help text was originally far more helpful, including
a url.  The message isn't telling you you need a kernel module, but that
you are using an old libcap.  It isn't a real problem right now if
you're not using the SMACK LSM, but to get rid of the message upgrade
your libcap from
http://www.kernel.org/pub/linux/libs/security/linux-privs/kernel-2.6/libcap-2.05.tar.gz

thanks,
-serge
