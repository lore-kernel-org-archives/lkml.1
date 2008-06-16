Return-Path: <linux-kernel-owner+w=401wt.eu-S1755957AbYFPPJ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957AbYFPPJ4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jun 2008 11:09:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752938AbYFPPJq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Jun 2008 11:09:46 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:38697 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752789AbYFPPJp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jun 2008 11:09:45 -0400
Message-ID: <485681BA.4060808@s5r6.in-berlin.de>
Date: Mon, 16 Jun 2008 17:07:38 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.13) Gecko/20080313 SeaMonkey/1.1.9
MIME-Version: 1.0
To: =?ISO-8859-1?Q?N=E9meth_M=E1rton?= <nm127@freemail.hu>
CC: David Newall <davidn@davidnewall.com>, Jeff Garzik <jgarzik@pobox.com>,
       netdev@vger.kernel.org, Trivial Patch Monkey <trivial@kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] 8139too: clean up spaces and TABs
References: <4853BB62.1060109@freemail.hu> <4853C8AD.9020407@s5r6.in-berlin.de> <48541165.7050304@freemail.hu> <485421C1.8010102@s5r6.in-berlin.de> <4854C9BF.8040900@freemail.hu>
In-Reply-To: <4854C9BF.8040900@freemail.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Németh Márton wrote:
> I have chosen the checkpatch.pl's output to compare the
> whether the old and the new code are better or not. Maybe that was a mistake.

Well, running checkpatch on source files (rather than patches) and
fixing the files up according to checkpatch's output and own good
judgement has two uses:
  - bring new unmerged code into shape before submission,
  - bring older mainline code into the canonical form as a basis
    for further work.  You certainly saw how lots and lots of such
    checkpatch-assisted cleanups went into arch/x86.  That's because
    they were found useful for the work on unifying the two x86
    architecture subtrees.
So, a coding style rework has its use even on legacy code if people have
plans with the code.  But keep in mind that (a) the whitespace rules
aren't hard and universally agreed upon rules, (b) coding style has a
number of other aspects of arguably greater importance than whitespace
style, like proper modularization, good choices of names, use of common
idioms and APIs instead of own inventions, and so on.
-- 
Stefan Richter
-=====-==--- -==- =----
http://arcgraph.de/sr/
