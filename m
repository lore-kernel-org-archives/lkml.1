Return-Path: <linux-kernel-owner+w=401wt.eu-S1751932AbXDBBlV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751932AbXDBBlV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 21:41:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751965AbXDBBlV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 21:41:21 -0400
Received: from tmailer.gwdg.de ([134.76.10.23]:55375 "EHLO tmailer.gwdg.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751932AbXDBBlV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 21:41:21 -0400
Date: Mon, 2 Apr 2007 03:41:01 +0200 (MEST)
From: Jan Engelhardt <jengelh@linux01.gwdg.de>
To: Edgardo Hames <ehames@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Rebuilding and checksumming the Linux kernel
In-Reply-To: <478c16ae0704011803ub1d401xfd7fb2bda61a9f39@mail.gmail.com>
Message-ID: <Pine.LNX.4.61.0704020339490.1245@yvahk01.tjqt.qr>
References: <478c16ae0704011156u5a34ae96lfd88a6da16d5726a@mail.gmail.com>
 <478c16ae0704011803ub1d401xfd7fb2bda61a9f39@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Spam-Report: Content analysis: 0.0 points, 6.0 required
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Apr 1 2007 22:03, Edgardo Hames wrote:

>> code will or should always produce the same output. Compilers are not
>> generally required to be deterministic.
>
> Could you please be a little more specific? We keep toolchains in our
> SCM tool,

Compile this, shush.

#include <stdio.h>
int main(void)
{
	printf("%s %s\n", __DATE__, __TIME__);
	return 0;
}


Jan
-- 
