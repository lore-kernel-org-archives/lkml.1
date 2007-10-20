Return-Path: <linux-kernel-owner+w=401wt.eu-S1763999AbXJTLmI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763999AbXJTLmI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Oct 2007 07:42:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756296AbXJTLlz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 20 Oct 2007 07:41:55 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:40389 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755979AbXJTLlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Oct 2007 07:41:55 -0400
To: Paolo Giarrusso <p.giarrusso@gmail.com>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Rob Landley <rob@landley.net>
Subject: Re: [uml-devel] User Mode Linux still doesn't build in 2.6.23-final.
References: <200710111754.46854.rob@landley.net>
	<200710200252.37919.p.giarrusso@gmail.com>
From: Nix <nix@esperi.org.uk>
Emacs: more than just a Lisp interpreter, a text editor as well!
Date: Sat, 20 Oct 2007 12:41:29 +0100
In-Reply-To: <200710200252.37919.p.giarrusso@gmail.com> (Paolo Giarrusso's message of "Sat, 20 Oct 2007 02:52:30 +0200")
Message-ID: <87y7dyhv2u.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-Rhyolite-Metrics: hades 104; Body=4 Fuz1=4 Fuz2=4
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 Oct 2007, Paolo Giarrusso told this:
> Guess most people are not using SMP right now, and that the error disappears 
> without that setting

It doesn't. It fails with non-SMP as well.

Rob, your patch works for me. (Not that the reboot into 2.6.23.1 was
problem-free: iproute2-071016 fails to understand the `police' action
and also somehow fails to bring up networking well enough for me to
locally NFS-mount my home directories, where 070710 had no trouble.
More on that soon to the appropriate people as soon as I've diagnosed
it...)
