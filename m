Return-Path: <linux-kernel-owner+w=401wt.eu-S1761168AbYBHAWZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761168AbYBHAWZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Feb 2008 19:22:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751080AbYBHAWR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Feb 2008 19:22:17 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:37766 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750947AbYBHAWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Feb 2008 19:22:16 -0500
Date: Fri, 8 Feb 2008 01:22:15 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: where is the capset kernel module?
In-Reply-To: <b6a2187b0802060356r19e59e67lfa572939545872e@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802061312060.23855@fbirervta.pbzchgretzou.qr>
References: <b6a2187b0802060013i2969a577x921be4d1a1202248@mail.gmail.com> 
 <b6a2187b0802060243u3d8187b8v878dddf9eb4d3cb0@mail.gmail.com> 
 <Pine.LNX.4.64.0802061225240.23855@fbirervta.pbzchgretzou.qr>
 <b6a2187b0802060356r19e59e67lfa572939545872e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 6 2008 19:56, Jeff Chua wrote:
>> >warning: `named' uses 32-bit capabilities (legacy support in use)
>> Yes it is a really interesting case I have seen before,
>> but did not bother to investigate.
>> CONFIG_SECURITY=y
>> CONFIG_SECURITY_CAPABILITIES=m or y
>
>Tried, but didn't help.
>
>Menuconfig can't select these as modules. So may be that's they need
>to be make modular.

O the joy of the make-it-nonmodular patch in 2.6.24.

>     [*] Enable different security models
>     [*]   Socket and Networking Security Hooks (NEW)
>     [*]   Default Linux Capabilities (NEW)
>     [*] File POSIX Capabilities (EXPERIMENTAL)
>     [ ] Root Plug Support (NEW)
