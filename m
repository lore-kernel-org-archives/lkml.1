Return-Path: <linux-kernel-owner+w=401wt.eu-S1756353AbYGYKLt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756353AbYGYKLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2008 06:11:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752716AbYGYKLl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jul 2008 06:11:41 -0400
Received: from mx1.redhat.com ([66.187.233.31]:53554 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537AbYGYKLl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2008 06:11:41 -0400
Date: Fri, 25 Jul 2008 06:11:27 -0400
From: Alan Cox <alan@redhat.com>
To: Toralf =?iso-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org, alan@redhat.com,
       Jeff Dike <jdike@addtoit.com>
Subject: Re: commit a352def21a642 breaks UML
Message-ID: <20080725101127.GA7237@devserv.devel.redhat.com>
References: <200807251112.10765.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200807251112.10765.toralf.foerster@gmx.de>
User-Agent: Mutt/1.4.1i
Organization: Red Hat UK Cyf., Amberley Place, 107-111 Peascod Street, Windsor, Berkshire, SL4 1TE, Y Deyrnas Gyfunol. Cofrestrwyd yng Nghymru a Lloegr o'r rhif cofrestru 3798903
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 25, 2008 at 11:12:08AM +0200, Toralf Förster wrote:
> Hello,
> 
> that commit produces a make error at my system:

Patches have been posted. um was poking around in the innards of the tty
layer in a file hidden in an arch subdirectory so it got missed. Swap that
problem chunk for

		tty_wakeup(tty)

