Return-Path: <linux-kernel-owner+w=401wt.eu-S1755907AbXK3Uwa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755907AbXK3Uwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2007 15:52:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752338AbXK3UwX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 30 Nov 2007 15:52:23 -0500
Received: from mail8.dotsterhost.com ([66.11.233.1]:36244 "HELO
	mail8.dotsterhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752301AbXK3UwW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2007 15:52:22 -0500
Message-ID: <47507818.8010808@crispincowan.com>
Date: Fri, 30 Nov 2007 12:52:40 -0800
From: Crispin Cowan <crispin@crispincowan.com>
Organization: Crispin's Labs
User-Agent: Thunderbird 2.0.0.6 (X11/20070801)
MIME-Version: 1.0
To: "Tvrtko A. Ursulin" <tvrtko.ursulin@sophos.com>
CC: linux-kernel@vger.kernel.org,
       LSM ML <linux-security-module@vger.kernel.org>
Subject: Re: Out of tree module using LSM
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tvrtko A. Ursulin wrote:
> During one recent LKML discussion
> (http://marc.info/?l=linux-kernel&amp;m=119267398722085&amp;w=2) about
> LSM going
> static  you called for LSM users to speak up.
Great big clue: If "LSM" is in the subject line, then cc: the LSM list
linux-security-module@vger.kernel.org

For LSM readers seeing this for the first time, the thread starts here
and goes for a while http://lkml.org/lkml/2007/11/28/106

I'm sympathetic to the desire to be able to provide a 3rd party LSM that
end users can install on their systems. That is why I advocated for
keeping the dynamic LSM interface. Getting the dynamic interface
restored faces a lot of challenges, but I hope that some kind of
solution can be found, because the alternative is to effectively force
vendors like Sophos to do it the "dirty" way by fishing in memory for
the syscall table. I would much rather that Linux offers you a way to do
what you need to do than force you to do nasty things.

Crispin

-- 
Crispin Cowan, Ph.D.               http://crispincowan.com/~crispin
CEO, Mercenary Linux		   http://mercenarylinux.com/
	       Itanium. Vista. GPLv3. Complexity at work

