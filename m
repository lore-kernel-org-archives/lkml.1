Return-Path: <linux-kernel-owner+w=401wt.eu-S1760993AbYCaOvq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760993AbYCaOvq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2008 10:51:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756069AbYCaOml
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 31 Mar 2008 10:42:41 -0400
Received: from sorrow.cyrius.com ([65.19.161.204]:3416 "EHLO sorrow.cyrius.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758240AbYCaOmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2008 10:42:40 -0400
Date: Mon, 31 Mar 2008 16:44:15 +0200
From: Martin Michlmayr <tbm@cyrius.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>,
       linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: nobody cared about IRQ 19 (firewire, on a HP 2510p notebook)
Message-ID: <20080331144415.GA2604@deprecation.cyrius.com>
References: <20080321153952.GA26354@deprecation.cyrius.com> <47E3E2CF.5070408@s5r6.in-berlin.de> <47EF757F.9080501@s5r6.in-berlin.de> <20080330161339.GC28821@deprecation.cyrius.com> <47EFD09D.3020906@s5r6.in-berlin.de> <alpine.LFD.1.10.0803302201110.3219@apollo.tec.linutronix.de> <20080331095729.GI28821@deprecation.cyrius.com> <alpine.LFD.1.10.0803311213020.3219@apollo.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.1.10.0803311213020.3219@apollo.tec.linutronix.de>
User-Agent: Mutt/1.5.16 (2007-06-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Thomas Gleixner <tglx@linutronix.de> [2008-03-31 12:17]:
> > I've attached all of that information.
> 
> Do you have CONFIG_NET_POLL_CONTROLLER enabled in your .config ? If
> yes, can you please disable it and check whether the problem persists ?

CONFIG_NET_POLL_CONTROLLER was indeed set.  When I disable it, the
problem goes away.

What does that mean?
-- 
Martin Michlmayr
http://www.cyrius.com/
