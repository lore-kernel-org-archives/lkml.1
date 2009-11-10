Return-Path: <linux-kernel-owner+w=401wt.eu-S1755455AbZKJAJG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755455AbZKJAJG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Nov 2009 19:09:06 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753871AbZKJAJF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Nov 2009 19:09:05 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:45952 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752578AbZKJAJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Nov 2009 19:09:05 -0500
To: "Tantilov, Emil S" <emil.s.tantilov@intel.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "e1000-devel@lists.sourceforge.net" 
	<e1000-devel@lists.sourceforge.net>
Subject: Re: [E1000-devel] [in-tree drivers] freezing e1000e in 2.6.31 (SMP only? MSI? PAUSE!)
References: <873a4rqu9o.fsf@spindle.srvr.nix>
	<EA929A9653AAE14F841771FB1DE5A1365F9923A504@rrsmsx501.amr.corp.intel.com>
	<87ljihnh81.fsf@spindle.srvr.nix>
From: Nix <nix@esperi.org.uk>
Emacs: because you deserve a brk today.
Date: Tue, 10 Nov 2009 00:08:47 +0000
In-Reply-To: <87ljihnh81.fsf@spindle.srvr.nix> (nix@esperi.org.uk's message of "Sun, 08 Nov 2009 15:55:58 +0000")
Message-ID: <87eio7meb4.fsf_-_@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-x.dcc-servers-Metrics: spindle 104; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 Nov 2009, nix@esperi.org.uk told this:

> On 6 Nov 2009, Emil S. Tantilov verbalised:
>> Also try disabling Tx pause frames:
>> ethtool -A fastnet tx off autoneg off
>
> Trying that now. No freezes yet, but I haven't really given it long
> enough.

I just did a large number of kernel-build-and-installs with frame
pointers over NFS over the errant link. No problems at all.

I think we can say this fixes it (works around it?)

Does this implicate the gigabit switch I'm talking to, or is it a kernel
bug? (It looks like the cheap Realteks at the other ends of this link
don't support pause frames at all: at least ethtool -a gives
-EOPNOTSUPP, but maybe they simply can't be turned off... hm, r8169.c
vaguely suggests that it supports them but can't turn them off without
source hacking.)
