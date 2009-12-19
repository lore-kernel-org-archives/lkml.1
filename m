Return-Path: <linux-kernel-owner+w=401wt.eu-S1752093AbZLSM1e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752093AbZLSM1e (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Dec 2009 07:27:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751996AbZLSM1d
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Dec 2009 07:27:33 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:37034 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751994AbZLSM1c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Dec 2009 07:27:32 -0500
Date: Sat, 19 Dec 2009 12:29:12 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: daw-news@taverner.cs.berkeley.edu (David Wagner)
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Security: Add prctl(PR_{GET,SET}_NETWORK) interface.
Message-ID: <20091219122912.780f63de@lxorguk.ukuu.org.uk>
In-Reply-To: <hgifbt$mme$1@taverner.cs.berkeley.edu>
References: <20091218030056.GC3047@heat>
	<20091218094955.32938765@nehalam>
	<hgifbt$mme$1@taverner.cs.berkeley.edu>
X-Mailer: Claws Mail 3.7.3 (GTK+ 2.16.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

O> I don't know of any reasonable way to introduce firewall rules
> that apply only to a specific process; nor do I know of any way
> for a user-level (non-root) process to specify and apply such
> rules.  So it doesn't sound to me like the firewalling infrastructure
> meets the requirements for which this patch was introduced.  Or did
> I miss something?

You can push BPF style filters onto sockets in Linux. They are not just
tied to some arbitary capture device. A process imposing its own isn't
too hard - imposing them on another process (or user) gets more complex
but cotnainers can probably do what is needed nowdays.

(We also have other weirdness like AX.25 where the mac address depends on
the user id of course)

Alan
