Return-Path: <linux-kernel-owner+w=401wt.eu-S1756198AbYCCRhJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756198AbYCCRhJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2008 12:37:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762149AbYCCRXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Mar 2008 12:23:48 -0500
Received: from mail.suse.de ([195.135.220.2]:41825 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762146AbYCCRXr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2008 12:23:47 -0500
To: Glauber Costa <gcosta@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, glommer@gmail.com,
       mingo@elte.hu, tglx@linutronix.de
Subject: Re: [PATCH 0/52] First attempt at smp integration
From: Andi Kleen <andi@firstfloor.org>
References: <1204564400-17636-1-git-send-email-gcosta@redhat.com>
Date: Mon, 03 Mar 2008 18:23:46 +0100
In-Reply-To: <1204564400-17636-1-git-send-email-gcosta@redhat.com> (Glauber Costa's message of "Mon\,  3 Mar 2008 14\:12\:28 -0300")
Message-ID: <p737igj7mcd.fsf@bingen.suse.de>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Glauber Costa <gcosta@redhat.com> writes:
>
> Comments are welcome.

The main difference between i386 and x86-64 smp boot up (among a lot
of quirks and workarounds in i386 that x86-64 doesn't have/need and
some trivialities) is that x86-64 follows the standard hotplug state
machine and i386 doesn't.

I would suggest that if you want to unify you convert i386 over to the new 
state machine first because that is the key difference. Everything else
after that is relatively simple. You can probably pattern that after
the original changeset who did this for x86-64.

The reason I never attempted this myself is that i was too worried about
regressions on old machines for i386 (this code is partly very fragile)
You'll likely encounter that problem. Just make sure to keep a stable
email address for some years to handle the fallout.

-Andi
