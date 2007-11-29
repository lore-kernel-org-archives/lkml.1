Return-Path: <linux-kernel-owner+w=401wt.eu-S1762375AbXK2AkO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762375AbXK2AkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 19:40:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755541AbXK2Aj5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 19:39:57 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:47193 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762282AbXK2Ajz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 19:39:55 -0500
Date: Thu, 29 Nov 2007 01:39:54 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: "J.A. =?UTF-8?B?TWFnYWxsw7Nu?=" <jamagallon@ono.com>
cc: "Linux-Kernel, " <linux-kernel@vger.kernel.org>
Subject: Re: void* arithmnetic
In-Reply-To: <20071129010531.22b3a71f@werewolf>
Message-ID: <Pine.LNX.4.64.0711290130170.22052@fbirervta.pbzchgretzou.qr>
References: <20071129010531.22b3a71f@werewolf>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Nov 29 2007 01:05, J.A. Magallón wrote:
>
>Since begin of the ages the build of the nvidia driver says things like
>this:
>

Explicitly adding -Wpointer-arith to ones own Makefile is like
admitting the code might be problematic. :->


I think sizeof(void *) == 1 is taken as granted as sizeof(int) >= 4
these days. Sigh.

