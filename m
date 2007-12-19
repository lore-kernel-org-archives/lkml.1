Return-Path: <linux-kernel-owner+w=401wt.eu-S1756008AbXLSVQ2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008AbXLSVQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2007 16:16:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752627AbXLSVQU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Dec 2007 16:16:20 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:57306 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750846AbXLSVQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2007 16:16:20 -0500
Date: Wed, 19 Dec 2007 22:16:19 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "linux-os (Dick Johnson)" <linux-os@analogic.com>
cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Trying to convert old modules to newer kernels
In-Reply-To: <Pine.LNX.4.61.0712191608160.4660@chaos.analogic.com>
Message-ID: <Pine.LNX.4.64.0712192215340.5524@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com>
 <Pine.LNX.4.64.0712192142060.5524@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.61.0712191608160.4660@chaos.analogic.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 19 2007 16:10, linux-os (Dick Johnson) wrote:
>> I anticipate the day removing __init causes a breakage, heh.
>> I mean, if all in-tree modules and LDD3 use it, it can't be wrong, can it?
>>
>>> plus got rid of all the code!
>>> static int32_t startup()
>>
>> I noticed that. Where's your "void" gone? :-)
>
>What void???
>

static __init int startup(void)
{
	...
}

Just a stylistic thing, but it has got a clear semantic difference to ().
