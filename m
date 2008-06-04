Return-Path: <linux-kernel-owner+w=401wt.eu-S1756814AbYFDAcr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814AbYFDAcr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 20:32:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750905AbYFDAcj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 20:32:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38435 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751925AbYFDAcj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 20:32:39 -0400
Date: Tue, 3 Jun 2008 17:32:14 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: avorontsov@ru.mvista.com
Cc: galak@kernel.crashing.org, wim@iguana.be, jochen@scram.de,
       sfr@canb.auug.org.au, segher@kernel.crashing.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8 v4] mpc83xx_wdt rework, support for mpc8610 and
 mpc8xx
Message-Id: <20080603173214.0bf71571.akpm@linux-foundation.org>
In-Reply-To: <20080604001739.GB24548@polina.dev.rtsoft.ru>
References: <20080602173726.GA24556@polina.dev.rtsoft.ru>
	<20080603164830.32457962.akpm@linux-foundation.org>
	<20080604001739.GB24548@polina.dev.rtsoft.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 4 Jun 2008 04:17:39 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> > Please put the subsystem identifier (eg, "watchdog" and "powerpc")
> > outside the [], for reasons which should be in
> > Documentation/SubmittingPatches, which used to be there but which got
> > lost.  Bascially the text inside [] is for temporary not-for-committing
> > information such as "rfc", "2.6.24-rc4", "resend", etc and should be stripped
> > by the email recipient before merging.
> 
> Yeah, I know. It is just hard to remember all the preferences.
> 
> For example, PowerPC maintainers asking to do patches with "[POWERPC]"
> identifier, this identifier purposely keeps intact for git-log.

Addition of "[powerpc]" if it was absent can be scripted.

However, the retaining of "[powerpc]" (etc) while not retaining "[rfc]"
(etc) is not practical.

Plus putting things into git with "[powerpc]" in the title is wrong. 
The chances are good that anyone who is taking such a patch off the
git-commits list (say, for a backport) will lose that part of the
title.  It should be "powerpc: "

(http://userweb.kernel.org/~akpm/dh.gif)
