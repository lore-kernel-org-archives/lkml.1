Return-Path: <linux-kernel-owner+w=401wt.eu-S1755919AbXHAWPP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919AbXHAWPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 18:15:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753256AbXHAWPB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 18:15:01 -0400
Received: from THUNK.ORG ([69.25.196.29]:44256 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250AbXHAWPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 18:15:00 -0400
Date: Wed, 1 Aug 2007 18:14:48 -0400
From: Theodore Tso <tytso@mit.edu>
To: Andi Kleen <ak@novell.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] Deprecate a.out ELF interpreters
Message-ID: <20070801221448.GF28106@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, Andi Kleen <ak@novell.com>,
	LKML <linux-kernel@vger.kernel.org>
References: <200708011431.19879.ak@novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200708011431.19879.ak@novell.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Do you mean deprecate a.out interpreters?

I could imagine that there might be some people running some very old
statically linked programs from a decade or so ago, but I agree they
are pretty small in number.  Is the fs/binfmt_aout.c causing problems?
It's only 562 lines of code...

						- Ted
