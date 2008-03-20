Return-Path: <linux-kernel-owner+w=401wt.eu-S1754830AbYCTLHJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754830AbYCTLHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 07:07:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752116AbYCTLG7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 07:06:59 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:35952 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007AbYCTLG6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 07:06:58 -0400
Message-ID: <47E24540.4050804@s5r6.in-berlin.de>
Date: Thu, 20 Mar 2008 12:06:40 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.12) Gecko/20080201 SeaMonkey/1.1.8
MIME-Version: 1.0
To: "Artem S. Tashkinov" <birdie@permonline.ru>
CC: Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org
Subject: Re: GIT commit description flag(s)
References: <47DC4104.1070109@permonline.ru> <alpine.LNX.1.00.0803181757020.8851@fbirervta.pbzchgretzou.qr> <47E09F53.5020201@permonline.ru>
In-Reply-To: <47E09F53.5020201@permonline.ru>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Artem S. Tashkinov wrote:
> I quite agree with you that the description is already there, but such 
> flags could help easily review or grep commits in order to identify your 
> areas of interest.
> 
> Even your example has ambiguity: "Wire up new timerfd syscalls" - It's 
> not easy to understand whether this particular commit is a bugfix, or it 
> speeds up things, or the old code which has been cleaned up, etc.

The fundamental problems
  - people sometimes chose bad summaries,
  - we can't always predict the full impact of the patch,
  - what's important for me isn't for you
cannot be solved by your proposed flags.

They can only be solved by
  - reviewing patches WRT good changelogs,
  - writing up extra summary release notes for areas of interest
    after the fact.

>>> It would be nice if [kernel] git commits had a flag [a char] (or a
>>> combination of) describing their main purpose which could be the
>>> following:
>>>
>>> bug Fix [F]
>>> Speed up/Performance [S]
>>> Revert [R]
>>> New functionality [N]

New bug [B]
Attempted bug fix which doesn't really work, a.k.a. nice Try [T]
Performance regression, a.k.a Downgrade [D]
-- 
Stefan Richter
-=====-==--- --== =-=--
http://arcgraph.de/sr/
