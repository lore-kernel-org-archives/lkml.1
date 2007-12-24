Return-Path: <linux-kernel-owner+w=401wt.eu-S1754802AbXLXDFn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802AbXLXDFn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 22:05:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751748AbXLXDFf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 22:05:35 -0500
Received: from slackadelic.com ([65.196.224.53]:49913 "EHLO
	mail.slackadelic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751459AbXLXDFe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 22:05:34 -0500
From: Carlos Corbacho <carlos@strangeworlds.co.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: x86: Increase PCIBIOS_MIN_IO to 0x1500 to fix nForce 4 suspend-to-RAM
Date: Mon, 24 Dec 2007 03:05:16 +0000
User-Agent: KMail/1.9.7
Cc: "H. Peter Anvin" <hpa@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux PM List <linux-pm@vger.kernel.org>, Greg KH <gregkh@suse.de>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       Len Brown <lenb@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
References: <200712231419.40207.carlos@strangeworlds.co.uk> <alpine.LFD.0.9999.0712231621340.21557@woody.linux-foundation.org> <alpine.LFD.0.9999.0712231703390.21557@woody.linux-foundation.org>
In-Reply-To: <alpine.LFD.0.9999.0712231703390.21557@woody.linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200712240305.18080.carlos@strangeworlds.co.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 24 December 2007 01:14:34 Linus Torvalds wrote:
> Side note: we could obviously undo the commit that triggered this for you
> [..]
> In other words, we'd have to go back to our original ordering, which Len
> said was fundamentally wrong. I don't think anybody really wants that.

Nor would I argue to do so.

> It would be better to figure out why "device_suspend()" apparently causes
> problems for your AML crud.

Will do - thanks for the pointer.

> Oh, and why is linux-kernel cc'd, but not linux-pm?

Because I like to compound my errors (I mean, if you're going to screw up, you 
might as well _really_ go for it).

-Carlos
-- 
E-Mail: carlos@strangeworlds.co.uk
Web: strangeworlds.co.uk
GPG Key ID: 0x23EE722D
