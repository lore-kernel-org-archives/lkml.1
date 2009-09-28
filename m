Return-Path: <linux-kernel-owner+w=401wt.eu-S1753281AbZI1Uvm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753281AbZI1Uvm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Sep 2009 16:51:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753219AbZI1Uvl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Sep 2009 16:51:41 -0400
Received: from icebox.esperi.org.uk ([81.187.191.129]:38137 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbZI1Uvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Sep 2009 16:51:39 -0400
To: Alexander Duyck <alexander.duyck@gmail.com>
Cc: e1000-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       netdev <netdev@vger.kernel.org>, bruce.w.allan@intel.com
Subject: Re: 2.6.31 regression: e1000e jumbo frames no longer work:  'Unsupported MTU setting'
References: <871vluc5wi.fsf@spindle.srvr.nix>
	<5f2db9d90909261914l3a927f4cya1dc5e4548688bce@mail.gmail.com>
From: Nix <nix@esperi.org.uk>
Emacs: don't cry -- it won't help.
Date: Mon, 28 Sep 2009 21:51:18 +0100
In-Reply-To: <5f2db9d90909261914l3a927f4cya1dc5e4548688bce@mail.gmail.com> (Alexander Duyck's message of "Sat, 26 Sep 2009 19:14:55 -0700")
Message-ID: <87ab0elrnd.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-dcc.uncw.edu-Metrics: spindle 1201; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27 Sep 2009, Alexander Duyck said:
> It looks like the problem is that the 82574 and 82583 seem to have
> their max_hw_frame_size values swapped.  You might try applying the
> patch below.  I am not sure if it will apply since I hand generated it

Applies fine: works fine. Thank you!

> using the git patch that seems to have introduced the problem, and I
> am sending the patch through an untested account that may mangle the
> patch.

Unmangled.

>        I will see about submitting an official patch for this
> sometime next few days.

I wonder if this belongs in -stable? People with an 82574 who are using
jumbo frames may well find their networks not coming up, if like me
they set a bunch of properties in one /sbin/ip call.
