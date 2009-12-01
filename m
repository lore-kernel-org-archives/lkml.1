Return-Path: <linux-kernel-owner+w=401wt.eu-S1754560AbZLAUb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754560AbZLAUb6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Dec 2009 15:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754394AbZLAUb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 1 Dec 2009 15:31:57 -0500
Received: from waste.org ([173.11.57.241]:60076 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754540AbZLAUb5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Dec 2009 15:31:57 -0500
Subject: Re: [Bug 14662] drm/i915: Select CONFIG_SHMEM
From: Matt Mackall <mpm@selenic.com>
To: Hugh Dickins <hugh.dickins@tiscali.co.uk>
Cc: Chris Wilson <chris@chris-wilson.co.uk>,
       Mateusz Kaduk <mateusz.kaduk@gmail.com>, Eric Anholt <eric@anholt.net>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <Pine.LNX.4.64.0912011906290.8058@sister.anvils>
References: <Pine.LNX.4.64.0912011906290.8058@sister.anvils>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Dec 2009 14:31:23 -0600
Message-ID: <1259699483.29740.1456.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-12-01 at 19:26 +0000, Hugh Dickins wrote:
> Hi Chris,
> 
> I'm slightly worried by this patch which went into Linus's git yesterday.
> 
> Thank you for looking into the issue, and coming up with what Mateusz
> has found to be a good workaround.
> 
> But is it the right fix?

This really does look like a band-aid. There's either a real problem in
tiny-shmem or alternately something scribbling on its aops? In which
case turning shmem on is just causing something different to get
scribbled on.

-- 
http://selenic.com : development and support for Mercurial and Linux


