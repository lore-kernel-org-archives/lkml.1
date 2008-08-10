Return-Path: <linux-kernel-owner+w=401wt.eu-S1753872AbYHJR3d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753872AbYHJR3d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Aug 2008 13:29:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752304AbYHJR30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Aug 2008 13:29:26 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:57620 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbYHJR3Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Aug 2008 13:29:25 -0400
Date: Sun, 10 Aug 2008 13:29:24 -0400 (EDT)
From: Jan Engelhardt <jengelh@medozas.de>
To: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
cc: linux-kernel@vger.kernel.org
Subject: Re: Does sysrq break something?
In-Reply-To: <200805122116.HIJ51599.VLOFOQFMSFtHJO@I-love.SAKURA.ne.jp>
Message-ID: <alpine.LNX.1.10.0805182212510.15590@fbirervta.pbzchgretzou.qr>
References: <200805122116.HIJ51599.VLOFOQFMSFtHJO@I-love.SAKURA.ne.jp>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2008-05-12 14:16, Tetsuo Handa wrote:
>Hello.
>
>I'm trying to get a sysrq dump when the system hangs.
>But unfortunately, typing sysrq key from the keyboard
>doesn't work after the system hangs.
>So, I'm trying to get a sysrq dump by automatically
>writing to /proc/sysrq-trigger using a program.

(a) make sure sysrq-over-keyboard is enabled
(b) if the system does not react to sysrq, it is unlikely
it is servicing any processes at all
(c) try xt_SYSRQ (xtables-addons 1.5.5), to hopefully
trigger sysrq over the network (receive routine may run
in interrupt context).

>In other words, does invoking sysrq routine break or taint something?

No.
