Return-Path: <linux-kernel-owner+w=401wt.eu-S1753098AbXFXVXQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098AbXFXVXQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2007 17:23:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751017AbXFXVXE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Jun 2007 17:23:04 -0400
Received: from taverner.CS.Berkeley.EDU ([128.32.168.222]:58361 "EHLO
	taverner.cs.berkeley.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231AbXFXVXD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2007 17:23:03 -0400
To: linux-kernel@vger.kernel.org
Path: not-for-mail
From: daw@cs.berkeley.edu (David Wagner)
Newsgroups: isaac.lists.linux-kernel
Subject: Re: [AppArmor 39/45] AppArmor: Profile loading and manipulation,
 pathname matching
Date: Sun, 24 Jun 2007 21:20:07 +0000 (UTC)
Organization: University of California, Berkeley
Message-ID: <f5mn67$4d4$2@taverner.cs.berkeley.edu>
References: <20070615200623.GA2616@elf.ucw.cz> <1182459594.20464.16.camel@moss-spartans.epoch.ncsc.mil> <20070622003436.GB6222@think.oraclecorp.com> <Line.LNX.4.64.0706212044590.2100@localhost.localdomain>
Reply-To: daw-usenet@taverner.cs.berkeley.edu (David Wagner)
NNTP-Posting-Host: taverner.cs.berkeley.edu
X-Trace: taverner.cs.berkeley.edu 1182720007 4516 128.32.168.222 (24 Jun 2007 21:20:07 GMT)
X-Complaints-To: news@taverner.cs.berkeley.edu
NNTP-Posting-Date: Sun, 24 Jun 2007 21:20:07 +0000 (UTC)
X-Newsreader: trn 4.0-test76 (Apr 2, 2001)
Originator: daw@taverner.cs.berkeley.edu (David Wagner)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

James Morris  wrote:
>The point is that the pathname model does not generalize, and that 
>AppArmor's inability to provide adequate coverage of the system is a 
>design issue arising from this.

I don't see it.  I don't see why you call this a design issue.  Isn't
this just a case where they haven't gotten around to implementing
network and IPC mediation yet?  How is that a design issue arising
from a pathname-based model?  For instance, one system I built (Janus)
provided complete mediation, including mediation of network and IPC,
yet it too used a pathname model for its policy file when describing
the policy for the filesystem.  That seems to contradict your statement.
