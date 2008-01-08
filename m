Return-Path: <linux-kernel-owner+w=401wt.eu-S1756862AbYAHTVt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862AbYAHTVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 14:21:49 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753407AbYAHTVm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 14:21:42 -0500
Received: from pasmtpa.tele.dk ([80.160.77.114]:39386 "EHLO pasmtpA.tele.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbYAHTVl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 14:21:41 -0500
Date: Tue, 8 Jan 2008 20:21:42 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Daniel Walker <dwalker@mvista.com>
Cc: Theodore Tso <tytso@mit.edu>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org, apw@shadowen.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH] Deprecate checkpatch.pl --file
Message-ID: <20080108192142.GA26491@uranus.ravnborg.org>
References: <20080108161403.GA11632@basil.nowhere.org> <1199811033.1756.29.camel@imap.mvista.com> <20080108175347.GA25968@uranus.ravnborg.org> <1199815279.1756.35.camel@imap.mvista.com> <20080108182048.GM27800@mit.edu> <1199817208.1756.47.camel@imap.mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1199817208.1756.47.camel@imap.mvista.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> What I was saying in my first email was we can throttle "patches"
> arbitrarily (I think Andrew/Linus even have a merge period for these
> types of patches) ..  So that's not the issue .. I feel style clean ups
> are fundamentally good.. So what we don't want to do is discourage the
> creation of good patches, which is what I think Andi is doing..

The way I read this:
+WARNING: Using --file mode. Please do not send patches to linux-kernel
+that change whole existing files if you did not significantly change most
+of the the file for other reasons anyways or just wrote the file newly
+from scratch. Pure code style patches have a significant cost in a
+quickly changing code base like Linux because they cause rejects
+with other changes.
does not discourage the creation of good patches.

But is discourage the creation of pure clean-up patches because it
may have a disturbing effect on several other peoples work.

	Sam
