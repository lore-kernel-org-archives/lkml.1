Return-Path: <linux-kernel-owner+w=401wt.eu-S1764217AbXGFV3T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764217AbXGFV3T (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jul 2007 17:29:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762840AbXGFV3N
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 6 Jul 2007 17:29:13 -0400
Received: from gherkin.frus.com ([192.158.254.49]:45596 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762692AbXGFV3M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jul 2007 17:29:12 -0400
Subject: 2.6.22-rc6 bad page error (followup)
To: linux-kernel@vger.kernel.org
Date: Fri, 6 Jul 2007 16:29:10 -0500 (CDT)
X-Mailer: ELM [version 2.4ME+ PL82 (25)]
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=US-ASCII
Message-Id: <20070706212910.BEAA8DBA1@gherkin.frus.com>
From: rct@gherkin.frus.com (Bob Tracy)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Same type of "stuff" happening with 2.6.22-rc7.  I've managed to narrow
it down somewhat.  The page corruption happens only when I've got the sound
driver loaded: might be a DMA kind of thing that's killing me.  Anyone got
any ideas how I might narrow it down further?  The sound modules loaded
include ALSA's "snd_es18xx" with all the various OSS-compatibility modules.
At the risk of making an inflammatory comment, I don't recall this kind of
thing happening when I was using the equivalent OSS driver.  N.B.: the ALSA
driver only recently (in the past few months) became usable on the Alpha,
and I made the switch to ALSA as soon as it was feasible to do so.  I may
try going back to the OSS driver (if it's still available) to see if the
problem goes away.  That would at least confirm my suspicions as to where
the problem lies.

Original message excerpted below:
>This happened on an Alpha computer (433au) running 2.6.22-rc6.  The
>error was triggered when I started up a NX KDE session, which I've
>done successfully on all occasions prior to this one.  In other words,
>I wasn't doing anything out of the ordinary...

>Bad page state in process 'gnome-terminal'
>(...)
>Bad page state in process 'syslogd'

-- 
-----------------------------------------------------------------------
Bob Tracy               | "Eagles may soar, but weasels don't get
rct@frus.com            |  sucked into jet engines."       --Anon
-----------------------------------------------------------------------
