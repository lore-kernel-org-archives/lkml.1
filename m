Return-Path: <linux-kernel-owner+w=401wt.eu-S1760907AbXLUMnn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760907AbXLUMnn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2007 07:43:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750876AbXLUMng
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 21 Dec 2007 07:43:36 -0500
Received: from sovereign.computergmbh.de ([85.214.69.204]:35285 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750723AbXLUMnf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2007 07:43:35 -0500
Date: Fri, 21 Dec 2007 13:43:34 +0100 (CET)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: James Courtier-Dutton <James@superbug.co.uk>
cc: =?ISO-8859-1?Q?=22J=2EA=2E_Magall=F3n=22?= <jamagallon@ono.com>,
       "linux-os (Dick Johnson)" <linux-os@analogic.com>,
       Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: Trying to convert old modules to newer kernels
In-Reply-To: <476BACD6.5060900@superbug.co.uk>
Message-ID: <Pine.LNX.4.64.0712211340210.21721@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.61.0712191503370.4688@chaos.analogic.com>
 <20071219202323.GH2310@csclub.uwaterloo.ca> <Pine.LNX.4.61.0712191555150.4514@chaos.analogic.com>
 <20071220150255.GE2308@csclub.uwaterloo.ca> <Pine.LNX.4.61.0712201107300.8261@chaos.analogic.com>
 <20071220182815.GA5438@uranus.ravnborg.org> <Pine.LNX.4.61.0712201623500.9531@chaos.analogic.com>
 <20071220220547.GA5641@uranus.ravnborg.org> <Pine.LNX.4.61.0712201757410.9907@chaos.analogic.com>
 <20071221005303.771032f3@werewolf> <476BACD6.5060900@superbug.co.uk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 21 2007 12:08, James Courtier-Dutton wrote:

> That being said, I don't think sse and mmx are available in kernel
> space, so I would have suggested doing all the grunt work in
> userspace would be better for this persons application so that he
> could use sse and mmx etc.
>
They are available, you just need to pay attention not to trash
a process's context.

IIRC this has been done for 387 FPUting. (The 'trigger' thing in
save_i387() in arch/x86/i387_32.c probably.) Probably not for SSE.
