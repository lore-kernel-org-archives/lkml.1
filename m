Return-Path: <linux-kernel-owner+w=401wt.eu-S1761983AbYAYXvX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761983AbYAYXvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2008 18:51:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755500AbYAYXvG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Jan 2008 18:51:06 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:49144 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752580AbYAYXvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2008 18:51:05 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <479A75D4.6070607@s5r6.in-berlin.de>
Date: Sat, 26 Jan 2008 00:50:44 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.11) Gecko/20071216 SeaMonkey/1.1.7
MIME-Version: 1.0
To: "Giacomo A. Catenazzi" <cate@cateee.net>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Valdis.Kletnieks@vt.edu,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Linux 2.6.24
References: <alpine.LFD.1.00.0801241506500.15329@hp.linux-foundation.org> <4799A773.2030702@cateee.net> <22000.1201255093@turing-police.cc.vt.edu> <200801251258.08707.rjw@sisk.pl> <4799D770.2070203@cateee.net>
In-Reply-To: <4799D770.2070203@cateee.net>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Giacomo A. Catenazzi wrote:
>> On Friday, 25 of January 2008, Valdis.Kletnieks@vt.edu wrote:
[-mm]
>>> should flush out most of the truly stupid mistakes, but those are
>>> usually found and fixed literally within hours.  Anyhow, the proper
>>> time for test compiles is *before* it goes into the git trees at
>>> all - it should have been tested before it gets sent to a
>>> maintainer for inclusion.
> 
> few hours, but a lot of changeset will broke bisect (few doc tell
> us how to continue bisecting on compile errors).
[...]
> I only want to raise the problem, to see if it is possible to improve
> testing environment without affecting the development of Linux.

How often is "bisectability" being broken already before merge in
subsystem trees, and how often only in the context of the merge result?
(Probably impossible to answer because nobody has the data.)

Much of the former type of breakage (if we really have such breakage)
could probably be found in mostly automated ways and by volunteer
testers, by regularly testing the subsystem trees.
-- 
Stefan Richter
-=====-==--- ---= ==-=-
http://arcgraph.de/sr/
