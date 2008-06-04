Return-Path: <linux-kernel-owner+w=401wt.eu-S1761075AbYFDRL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761075AbYFDRL1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 13:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754902AbYFDRLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 13:11:17 -0400
Received: from mx1.redhat.com ([66.187.233.31]:36485 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754305AbYFDRLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 13:11:17 -0400
Date: Wed, 4 Jun 2008 13:10:56 -0400
From: Alan Cox <alan@redhat.com>
To: Joe Peterson <joe@skyrush.com>
Cc: Alan Cox <alan@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       David Newall <davidn@davidnewall.com>, Willy Tarreau <w@1wt.eu>,
       Harald Dunkel <harald.dunkel@t-online.de>, linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
Message-ID: <20080604171056.GB17875@devserv.devel.redhat.com>
References: <48438126.3080308@t-online.de> <20080602053256.GF5609@1wt.eu> <20080602091016.571dda7c@core> <4843B6EE.8080104@davidnewall.com> <20080602102033.63e4cd18@core> <48441138.90503@skyrush.com> <20080602155133.GC933@devserv.devel.redhat.com> <4846A9F4.40003@skyrush.com> <20080604151649.GB12625@devserv.devel.redhat.com> <4846C85E.7080309@skyrush.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4846C85E.7080309@skyrush.com>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> tty = current->signal->tty = -142080000 or 0xf7880800
> task->pgrg                 = -142405824 or 0xf7830f40

task->pgrp is a struct pid - you need the value it holds
