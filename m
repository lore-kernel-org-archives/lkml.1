Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755407Ab0BIRci (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 12:32:38 -0500
Received: from icebox.esperi.org.uk ([81.187.191.129]:37725 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab0BIRcg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 12:32:36 -0500
To: Nigel Cunningham <ncunningham@crca.org.au>
Cc: Bill Davidsen <davidsen@tmr.com>, tuxonice-devel@lists.tuxonice.net,
       linux-kernel@vger.kernel.org, linux-crypto@vger.kernel.org
Subject: Re: [TuxOnIce-devel] LZO irreversible output?
References: <4B69ECE5.5060505@crca.org.au> <201002032354.11284.rjw@sisk.pl>
	<4B6A4F07.3090509@crca.org.au> <hkneh9$djl$1@ger.gmane.org>
	<4B6FCC47.2030705@crca.org.au>
From: Nix <nix@esperi.org.uk>
Emacs: a learning curve that you can use as a plumb line.
Date: Tue, 09 Feb 2010 17:32:27 +0000
In-Reply-To: <4B6FCC47.2030705@crca.org.au> (Nigel Cunningham's message of "Mon, 08 Feb 2010 19:33:11 +1100")
Message-ID: <874olq1fis.fsf@spindle.srvr.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b29 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-URT-Metrics: spindle 1060; Body=5 Fuz1=5 Fuz2=5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8 Feb 2010, Nigel Cunningham verbalised:
> That said, the actual code that TuxOnIce uses does already initialise
> the variable to PAGE_SIZE, so it seems that I might just have to run
> with the checking code enabled (with this fix) for a while, until the
> issue is found.

If you push the fix somewhere I'll run with it as well and see if I can
make this problem happen again. (So far I've only seen it with both
compression and max_workers > 1, but I haven't done a systematic check
for this so it could be an illusion.)
