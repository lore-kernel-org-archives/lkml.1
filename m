Return-Path: <linux-kernel-owner+w=401wt.eu-S1756115AbZFOGFz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756115AbZFOGFz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jun 2009 02:05:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752331AbZFOGFr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 15 Jun 2009 02:05:47 -0400
Received: from vm1.die-welt.net ([84.246.122.34]:58827 "EHLO chi.die-welt.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751078AbZFOGFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jun 2009 02:05:47 -0400
X-Greylist: delayed 578 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Jun 2009 02:05:47 EDT
Date: Mon, 15 Jun 2009 07:56:08 +0200
From: Evgeni Golov <evgeni@debian.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] use the TASK_COMM_LEN macro instead of
	sizeof(tsk->comm)
Message-ID: <20090615055608.GH18660@dragonheart.kerker.die-welt.net>
References: <1244998668-27078-1-git-send-email-sargentd@die-welt.net> <1244998668-27078-2-git-send-email-sargentd@die-welt.net> <20090615001410.24327266@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090615001410.24327266@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 15, 2009 at 12:14:10AM +0100, Alan Cox wrote:
> On Sun, 14 Jun 2009 18:57:48 +0200
> Evgeni Golov <sargentd@die-welt.net> wrote:
> 
> > sizeof(tsk->comm) == TASK_COMM_LEN, always, so why not use it?
> 
> Because if the size ever changes the existing code will remain correct
> and your changes will become a dangerous buffer overrun ?

But shouldn't TASK_COMM_LEN change then too?
Just wondering, in the end it's a cosmetic cange, but looking at the 
code, we rely on TASK_COMM_LEN in other places often enough to break 
something when a task->comm is not TASK_COMM_LEM big.

Regards
Evgeni
