Return-Path: <linux-kernel-owner+w=401wt.eu-S1751814AbYJUTMA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751814AbYJUTMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 15:12:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752030AbYJUTLv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 15:11:51 -0400
Received: from smtp-outbound-1.vmware.com ([65.115.85.69]:44605 "EHLO
	smtp-outbound-1.vmware.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752020AbYJUTLu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 15:11:50 -0400
Subject: Re: [PATCH 0/3] Improve TSC as a clocksource under VMware
From: Alok Kataria <akataria@vmware.com>
Reply-To: akataria@vmware.com
To: Chris Snook <csnook@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, LKML <linux-kernel@vger.kernel.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Daniel Hecht <dhecht@vmware.com>, Jeff Hansen <x@jeffhansen.com>
In-Reply-To: <48FD6EDC.5010801@redhat.com>
References: <1224552902.2640.88.camel@alok-dev1>
	 <48FD6EDC.5010801@redhat.com>
Content-Type: text/plain
Organization: VMware INC.
Date: Tue, 21 Oct 2008 12:11:49 -0700
Message-Id: <1224616309.6161.63.camel@alok-dev1>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-40.el5_1.1) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-20 at 22:55 -0700, Chris Snook wrote:
> Alok Kataria wrote:
> > This patch set makes some changes to the TSC code, so that it is always
> > used as the default clocksource when running under VMware.
> > The first 2 patches do the ground work of adding code to detect if we
> > are running under VMware.
> > The third patch adds a tsc_reliable flag which tells us that TSC is
> > reliable on this system, so that we can skip some tests which can
> > potentially mark TSC as unstable. Details under individual patch
> > headers.
> 
> Do you intend for this to supplement Jeff Hansen's tsc=stable patch, or to
> replace it?  If you intend to supplement it, you should rework your submission
> to make sure that both your autodetection and his command-line option use the
> same internal mechanism, and if you intend to replace it, you should say this
> explicitly, and justify it.  Either way, you should definitely CC Jeff on the
> submission, as I am doing now.

Hi Chris,

I had made this change to supplement Jeff's change, but I notice that
his change is not in any of the trees yet. Let me incorporate that in
the next iteration of this patch.

Thanks,
Alok
> 
> -- Chris

