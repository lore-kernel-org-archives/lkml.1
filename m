Return-Path: <linux-kernel-owner+w=401wt.eu-S1755618AbXIQSMF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755618AbXIQSMF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Sep 2007 14:12:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753661AbXIQSLz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Sep 2007 14:11:55 -0400
Received: from gw.goop.org ([64.81.55.164]:59780 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649AbXIQSLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Sep 2007 14:11:55 -0400
Message-ID: <46EEC368.1040308@goop.org>
Date: Mon, 17 Sep 2007 11:11:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070719)
MIME-Version: 1.0
To: David Madore <david.madore@ens.fr>
CC: linux-kernel@vger.kernel.org
Subject: Re: patch/option to wipe memory at boot?
References: <20070917155149.GA5453@clipper.ens.fr>
In-Reply-To: <20070917155149.GA5453@clipper.ens.fr>
X-Enigmail-Version: 0.95.3
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

David Madore wrote:
> Is there a patch or a boot option or something which wipes all
> available (physical) RAM at boot (or better, fills it with a fixed
> signature like 0xdeadbeef)?  I'm getting phony ECC errors and I'd like
> to test whether they go away when the RAM is properly initialized.
> Also, I'd like to know exactly which parts of RAM are being used and
> which are untouched since boot (hence the 0xdeadbeef signature).
>
> If this patch/option doesn't exist, can anyone give me a hint as to
> where and how it would be best to add this?  (I'm afraid I'm very
> ignorant as to how Linux sets up its RAM mapping.)  I'm concerned
> about x86 and x86_64.
>
> PS: I'm not finicky: it's all right if a couple of megabytes at the
> bottom of RAM are not scrubbed (I'm more interested about the top
> gigabyte-or-so), especially if they're guaranteed to be used by the
> kernel.
>   

Boot memtest86 for a little while before booting the kernel?  And if you
haven't already run it for a while, then that would be your first step
anyway.

    J
