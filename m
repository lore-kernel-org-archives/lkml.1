Return-Path: <linux-kernel-owner+w=401wt.eu-S1753769AbXFXUvv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753769AbXFXUvv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 16:51:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752025AbXFXUvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 16:51:41 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:48717 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755450AbXFXUvk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 16:51:40 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
	pathname matching
Date: Sun, 24 Jun 2007 20:48:46 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <f5mlbe$29j$3@taverner.cs.berkeley.edu>
References: <20070615200623.GA2616@elf.ucw.cz> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil> <20070622080640.GB14593@suse.de> <1182513228.24664.24.camel@moss-spartans.epoch.ncsc.mil>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1182718126 2355 128.32.168.222 (24 Jun 2007 20:48:46 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sun, 24 Jun 2007 20:48:46 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Smalley  wrote:
>On Fri, 2007-06-22 at 01:06 -0700, John Johansen wrote:
>> No the "incomplete" mediation does not flow from the design.  We have
>> deliberately focused on doing the necessary modifications for pathname
>> based mediation.  The IPC and network mediation are a wip.
>
>The fact that you have to go back to the drawing board for them is that
>you didn't get the abstraction right in the first place.

Calling this "going back to the drawing board" board strikes me as an
unfair criticism, when the real situation is that in the future the AA
folks will need to extend their code to mediate network and IPC (not
throw all the current code away and start over from scratch, and not
replace big swaths of the current code).
