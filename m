Return-Path: <linux-kernel-owner+w=401wt.eu-S1758678AbYHFS4t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758678AbYHFS4t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 14:56:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755676AbYHFS4l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 14:56:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38415 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754499AbYHFS4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 14:56:40 -0400
Date: Wed, 6 Aug 2008 20:57:19 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jason Wessel <jason.wessel@windriver.com>
Cc: Andi Kleen <andi@firstfloor.org>, jmerkey@wolfmountaingroup.com,
       Nick Piggin <nickpiggin@yahoo.com.au>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Josh Boyer <jwboyer@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] Merkey's Kernel Debugger
Message-ID: <20080806185719.GE24801@one.firstfloor.org>
References: <17494.166.70.238.46.1217784156.squirrel@webmail.wolfmountaingroup.com> <Pine.LNX.4.64.0808051140150.6309@anakin> <33030.166.70.238.45.1217948565.squirrel@webmail.wolfmountaingroup.com> <200808060133.10457.nickpiggin@yahoo.com.au> <87r6926dsr.fsf@basil.nowhere.org> <4899DD9F.6020007@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4899DD9F.6020007@windriver.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> It depends how you look at the problem.  I would agree that the use of

Yes I left the possibility of a "someone writing a in kernel kgdb UI" 
out. Indeed that would be a possibility. 

On the other hand I'm not sure it would save all that much code 
versus just directly working on top of die notifiers.

Also the gdb stub interface definitely has its limitations too.

> > be quite possible to have a multitude of debuggers just using
> > them. In fact that's already the cases, kprobes and kgdb and
> > kdump are all kinds of debuggers using such hooks.
> >
> 
> I would agree that the possibility exists to use the hooks directly,

It's not just a possibility, they are already used by multiple
debugger like subsystems. e.g. kprobes is certainly a kind of debugger.

-Andi
