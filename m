Return-Path: <linux-kernel-owner+w=401wt.eu-S1757197AbYBKPeA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757197AbYBKPeA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Feb 2008 10:34:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754113AbYBKPdw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 11 Feb 2008 10:33:52 -0500
Received: from mx1.redhat.com ([66.187.233.31]:37655 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754123AbYBKPdv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Feb 2008 10:33:51 -0500
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kgdb in git-x86#mm review
References: <20080211015321.GA27376@one.firstfloor.org>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Mon, 11 Feb 2008 10:32:46 -0500
In-Reply-To: <20080211015321.GA27376@one.firstfloor.org> (Andi Kleen's message of "Mon, 11 Feb 2008 02:53:21 +0100")
Message-ID: <y0mhcgf4ig1.fsf@ton.toronto.redhat.com>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andi Kleen <andi@firstfloor.org> writes:

> [...]  The kgdb code in git-x86#mm is right now is totally broken of
> course because the CFI annotations in assembler code are gone now,
> but they are needed for gdb use.  [...]

This loss of CFI data is unfortunate for other potential consumers
too, such as systemtap, which intends to supplement its current stack
backtracing heuristics with CFI data.

- FChE
