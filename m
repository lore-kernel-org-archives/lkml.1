Return-Path: <linux-kernel-owner+w=401wt.eu-S1757457AbZLZBSG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757457AbZLZBSG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Dec 2009 20:18:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755019AbZLZBSF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 25 Dec 2009 20:18:05 -0500
Received: from sj-iport-6.cisco.com ([171.71.176.117]:44087 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754482AbZLZBSA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Dec 2009 20:18:00 -0500
Authentication-Results: sj-iport-6.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApoEANryNEurR7Hu/2dsb2JhbAC/H5UXhDME
X-IronPort-AV: E=Sophos;i="4.47,455,1257120000"; 
   d="scan'208";a="456667306"
From: Roland Dreier <rdreier@cisco.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Sergei Trofimovich <slyich@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
       Sergei Trofimovich <slyfox@inbox.ru>
Subject: Re: [PATCH] Kbuild: set LC_MESSAGES=C (as LC_CTYPE=C is)
References: <1261761235-9431-1-git-send-email-slyfox@inbox.ru>
	<4B354C70.1060109@zytor.com>
X-Message-Flag: Warning: May contain useful information
Date: Fri, 25 Dec 2009 17:17:59 -0800
In-Reply-To: <4B354C70.1060109@zytor.com> (H. Peter Anvin's message of "Fri,
	25 Dec 2009 15:36:16 -0800")
Message-ID: <adar5qizg6w.fsf@roland-alpha.cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 26 Dec 2009 01:17:59.0849 (UTC) FILETIME=[435BC990:01CA85C9]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


 > The whole reason with only setting some LC_* to C was to be able to
 > leave LC_MESSAGES intact, but it seems it breaks on too many real-life
 > systems.

 > As such, I suggest we should set LC_ALL=C and get rid of the rest of it:

Seems unfortunate to lose localized error messages.  (Although in my
en_US.UTF-8 case, all I get is non-ASCII quote characters)

This all started because of the awk invocation in arch/x86/lib.  Maybe
the best idea would be to confine the locale monkeying to that one
place?

 - R.
