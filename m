Return-Path: <linux-kernel-owner+w=401wt.eu-S1762798AbYBFLkc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762798AbYBFLkc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2008 06:40:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757757AbYBFLkW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Feb 2008 06:40:22 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:43559 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754508AbYBFLkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2008 06:40:21 -0500
Date: Wed, 6 Feb 2008 12:40:20 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Jeff Chua <jeff.chua.linux@gmail.com>
cc: lkml <linux-kernel@vger.kernel.org>
Subject: Re: where is the capset kernel module?
In-Reply-To: <b6a2187b0802060243u3d8187b8v878dddf9eb4d3cb0@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0802061225240.23855@fbirervta.pbzchgretzou.qr>
References: <b6a2187b0802060013i2969a577x921be4d1a1202248@mail.gmail.com>
 <b6a2187b0802060243u3d8187b8v878dddf9eb4d3cb0@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Feb 6 2008 18:43, Jeff Chua wrote:
>On Feb 6, 2008 4:13 PM, Jeff Chua <jeff.chua.linux@gmail.com> wrote:
>> Latest linux git complained about this ...
>>
>> named: capset failed: Operation not permitted: please ensure that the
>> capset kernel module is loaded.  see insmod(8)
>
>How this started was that with the latest git linux, I got this warning ...
>
>warning: `named' uses 32-bit capabilities (legacy support in use)

Yes it is a really interesting case I have seen before,
but did not bother to investigate.
Is

CONFIG_SECURITY=y
CONFIG_SECURITY_CAPABILITIES=m or y

working?
