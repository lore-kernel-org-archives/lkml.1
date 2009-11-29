Return-Path: <linux-kernel-owner+w=401wt.eu-S1752367AbZK2Xb6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367AbZK2Xb6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Nov 2009 18:31:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751956AbZK2Xb5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Nov 2009 18:31:57 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:39709 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865AbZK2Xb4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Nov 2009 18:31:56 -0500
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org,
       Linux-Kernel-Mailing-List <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.31.5 x86-64 KVM: 'emulation failed (pagetable) rip 7fb49335da7b 66 0f 7f 07'
References: <87skbzvdgd.fsf@spindle.srvr.nix> <4B125051.6010506@redhat.com>
	<87k4x9saqn.fsf@spindle.srvr.nix> <4B1283F5.5060204@redhat.com>
From: Nix <nix@esperi.org.uk>
Emacs: because extension languages should come with the editor built in.
Date: Sun, 29 Nov 2009 23:31:45 +0000
In-Reply-To: <4B1283F5.5060204@redhat.com> (Avi Kivity's message of "Sun, 29 Nov 2009 16:23:49 +0200")
Message-ID: <87y6lorjq6.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-wuwien-Metrics: spindle 1290; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29 Nov 2009, Avi Kivity stated:
> Most likely, either this or something similar is called on a userspace
> device driver.  Can you check if this is triggered by starting X?

*sigh* I just wasted twenty minutes trying to find some way, *any* way
to not start X under Ubuntu Karmic, so as to test this. None is evident.
I can't even figure out what and where in upstart's horrific dependency
tangle is starting X in the first place: deleting suspicious-looking
things from rc*.d has no effect at all. I can't even tell if rc*.d is
still used, nor if the concept of runlevel is even meaningful any
longer. There are lots of things googleable that claim to say how to do
this, but all relate to the non-dependency-based inittab-emulating
method used in previous Ubuntu versions.

Anyone know?
