Return-Path: <linux-kernel-owner+w=401wt.eu-S1753291AbZIKBjE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753291AbZIKBjE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Sep 2009 21:39:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752724AbZIKBjE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Sep 2009 21:39:04 -0400
Received: from mx1-old.redhat.com ([66.187.233.31]:49223 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752634AbZIKBjC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Sep 2009 21:39:02 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
X-Fcc: ~/Mail/linus
Cc: "H. Peter Anvin" <hpa@zytor.com>, David Daney <ddaney@caviumnetworks.com>,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org
Subject: Re: [PATCH 02/10] x86: Convert BUG() to use unreachable()
In-Reply-To: Linus Torvalds's message of  Thursday, 10 September 2009 18:13:07 -0700 <alpine.LFD.2.01.0909101806110.3654@localhost.localdomain>
References: <4AA991C1.1050800@caviumnetworks.com>
	<1252627011-2933-2-git-send-email-ddaney@caviumnetworks.com>
	<4AA9A031.5000602@zytor.com>
	<alpine.LFD.2.01.0909101806110.3654@localhost.localdomain>
Emacs: if SIGINT doesn't work, try a tranquilizer.
Message-Id: <20090911013743.1CF13AEF@magilla.sf.frob.com>
Date: Thu, 10 Sep 2009 18:37:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> There are other cases where that kind of config-time testing could be 
> useful, and we could avoid doing various gcc checks dynamically from 
> within 'make' (along with checking for known-buggy versions etc).

I quite agree that this would be an improvement for many sorts of compiler
feature (and other tool detail) conditionalization.


Thanks,
Roland
