Return-Path: <linux-kernel-owner+w=401wt.eu-S934517AbYAaWKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934517AbYAaWKv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:10:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763233AbYAaWKe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:10:34 -0500
Received: from outbound-mail-27.bluehost.com ([69.89.17.193]:56952 "HELO
	outbound-mail-27.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1758274AbYAaWKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:10:33 -0500
X-Greylist: delayed 419 seconds by postgrey-1.27 at vger.kernel.org; Thu, 31 Jan 2008 17:10:33 EST
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] x86: introduce /dev/mem restrictions with a config option
Date: Thu, 31 Jan 2008 14:02:46 -0800
User-Agent: KMail/1.9.6 (enterprise 0.20071204.744707)
Cc: Arjan van de Ven <arjan@infradead.org>,
       Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       davej@redhat.com, mingo@elte.hu, tglx@tglx.de
References: <20080130124853.184ef782@laptopd505.fenrus.org> <20080131090839.7f610a6a@laptopd505.fenrus.org> <47A2086F.2040501@zytor.com>
In-Reply-To: <47A2086F.2040501@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801311402.46833.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 218.214.131.169 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, January 31, 2008 9:42 am H. Peter Anvin wrote:
> Arjan van de Ven wrote:
> > On Thu, 31 Jan 2008 17:53:04 +0100 (CET)
> >
> > Jan Engelhardt <jengelh@computergmbh.de> wrote:
> >> On Jan 30 2008 12:48, Arjan van de Ven wrote:
> >>> Subject: [PATCH] x86: introduce /dev/mem restrictions with a
> >>> config option
> >>>
> >>> This patch introduces a restriction on /dev/mem: Only non-memory
> >>> can be read or written unless the newly introduced config option
> >>> is set.
> >>
> >> Would not it be nicer to add a /dev/pcimem that implements the
> >> given restrictive semantics?
> >>
> >> Maybe it's just wishful thinking, but I am dreaming of an
> >> unprivileged X, and /dev/pcimem (owned by an 'x11' user or so)
> >> would be a step in that direction.
> >
> > /dev/pcimem is wrong; X can use the exact bar in sysfs already.
> > This is more for compatibility with legacy X
>
> Legacy X, and non-BAR X memory (originally ISA, of course; now
> probably more often "stolen system memory").

For legacy memory, we actually have /sys/bus/pci/<busno>/legacy_mem 
(though ia64 may be the only supported platform).  It's actually 
required on some arches due to the way this space is allocated across 
the system.

Jesse
