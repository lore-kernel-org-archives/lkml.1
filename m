Return-Path: <linux-kernel-owner+w=401wt.eu-S1754307AbXLXDXm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754307AbXLXDXm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2007 22:23:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752061AbXLXDXb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Dec 2007 22:23:31 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:30383 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751173AbXLXDXa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2007 22:23:30 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Stephane Ascoet <stephaneascoet@free.fr>
Subject: Re: do not stop/start devices in suspend/resume path: the SCSI case
Date: Sun, 23 Dec 2007 20:21:35 -0700
User-Agent: KMail/1.9.6 (enterprise 0.20070907.709405)
Cc: Jiri Slaby <jirislaby@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, matthew@wil.cx,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-pm@lists.linux-foundation.org, drzeus@drzeus.cx,
       linux-acpi@vger.kernel.org, Adam Belay <ambx1@neo.rr.com>,
       Matthieu Castet <castet.matthieu@free.fr>,
       Li Shaohua <shaohua.li@intel.com>, Len Brown <lenb@kernel.org>
References: <4745F77C.7040402@gmail.com> <200712051124.18852.bjorn.helgaas@hp.com> <476F0ED5.3090609@free.fr>
In-Reply-To: <476F0ED5.3090609@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712232021.36835.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 23 December 2007 6:43:49 pm Stephane Ascoet wrote:
> Bjorn Helgaas a écrit :
> > Good.  It's not clear to me whether it is safe to leave devices
> > enabled while we sleep.  I don't see an actual problem, but there
> > might be something related to hotplug while we're asleep or something.
> > So I'll cc: some additional people who might have some insight.
>
> Hi, is there a chance for SCSI sleeping being managed by ACPI(it seems
> to be the case for IDE)?

I'm sorry, I don't know the answer to this.

Bjorn

