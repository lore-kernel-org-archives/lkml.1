Return-Path: <linux-kernel-owner+w=401wt.eu-S1757302AbYFDQxF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302AbYFDQxF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 12:53:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbYFDQwy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 12:52:54 -0400
Received: from shadow.wildlava.net ([67.40.138.81]:32832 "EHLO
	shadow.wildlava.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751762AbYFDQwy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 12:52:54 -0400
Message-ID: <4846C85E.7080309@skyrush.com>
Date: Wed, 04 Jun 2008 10:52:46 -0600
From: Joe Peterson <joe@skyrush.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080505)
MIME-Version: 1.0
To: Alan Cox <alan@redhat.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, David Newall <davidn@davidnewall.com>,
       Willy Tarreau <w@1wt.eu>, Harald Dunkel <harald.dunkel@t-online.de>,
       linux-kernel@vger.kernel.org
Subject: Re: 2.6.25.3: su gets stuck for root
References: <48434D57.6030801@skyrush.com> <48438126.3080308@t-online.de> <20080602053256.GF5609@1wt.eu> <20080602091016.571dda7c@core> <4843B6EE.8080104@davidnewall.com> <20080602102033.63e4cd18@core> <48441138.90503@skyrush.com> <20080602155133.GC933@devserv.devel.redhat.com> <4846A9F4.40003@skyrush.com> <20080604151649.GB12625@devserv.devel.redhat.com>
In-Reply-To: <20080604151649.GB12625@devserv.devel.redhat.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Cox wrote:
> See what tty->pgrp is at that point when it hangs and that might identify
> who is owning the tty and tty setup

tty = current->signal->tty = -142080000 or 0xf7880800
task->pgrg                 = -142405824 or 0xf7830f40

		-Joe

