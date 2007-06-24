Return-Path: <linux-kernel-owner+w=401wt.eu-S1754615AbXFXUsu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615AbXFXUsu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 16:48:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751531AbXFXUsn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 16:48:43 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:48700 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751491AbXFXUsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 16:48:41 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
Date: Sun, 24 Jun 2007 20:45:47 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <f5ml5r$29j$2@taverner.cs.berkeley.edu>
References: <20070615200623.GA2616@elf.ucw.cz> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain> <467B4D61.3020509@novell.com> <1182514816.24664.49.camel@moss-spartans.epoch.ncsc.mil>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1182717947 2355 128.32.168.222 (24 Jun 2007 20:45:47 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sun, 24 Jun 2007 20:45:47 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley  wrote:
>That would certainly help, although one might quibble with the use of
>the word "confinement" at all wrt AppArmor (it has a long-established
>technical meaning that implies information flow control, and that goes
>beyond even complete mediation - it requires global and persistent
>protection of the data based on its properties, which requires stable
>and unambiguous identifiers).

1. Yes, that's the usage that has the greatest historical claim, but
"confinement" has also been used in the security community to refer to
limiting the overt side effects a process can have rather than controlling
information flow.  The term "confinement" is arguably ambiguous, but I
think there is a semi-established meaning that doesn't imply information
flow control.

2. This is a can of worms we probably don't want to open.  Keep in
mind that SELinux doesn't meet definition of confinement in Lampson's
original paper, either, because it only restricts overt information flows.
SELinux doesn't prevent covert channels, even though Lampson's original
paper included them as part of the confinement problem.  Yet I don't
think it would be reasonable to criticize someone for describing SELinux
as a tool for "confinement".  I don't know of any practical solution
that solves the confinement problem as Lampson envisioned it.  I'd
recommend making decisions on the basis of whether the mechanisms are
useful, rather than whether they solve Lampson's notion of the
"confinement" problem.
