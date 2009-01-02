Return-Path: <linux-kernel-owner+w=401wt.eu-S932092AbZABV7l@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932092AbZABV7l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jan 2009 16:59:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758832AbZABV7a
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Jan 2009 16:59:30 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:49879 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758735AbZABV73 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jan 2009 16:59:29 -0500
Date: Fri, 2 Jan 2009 23:01:05 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [incremental-PATCH-for-Sam's-Review] ACPI: use ccflags-y instead of EXTRA_CFLAGS
Message-ID: <20090102220105.GB8494@uranus.ravnborg.org>
References: <1230720725-9376-1-git-send-email-lenb@kernel.org> <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com> <20081231133901.GB2388@uranus.ravnborg.org> <87bpusv31n.fsf@basil.nowhere.org> <20081231153441.GA3475@uranus.ravnborg.org> <alpine.LFD.2.00.0901021636050.3590@localhost.localdomain> <20090102215208.GA8494@uranus.ravnborg.org> <87iqoxjrsw.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87iqoxjrsw.fsf@basil.nowhere.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 02, 2009 at 10:56:15PM +0100, Andi Kleen wrote:
> Sam Ravnborg <sam@ravnborg.org> writes:
> >
> > The conversion from ACPI_CFLAGS to ccflags-y is fine.
> > And if acpi really require -Os then this part is also OK -
> > I just did not get *why* acpi needs -Os
> 
> None of ACPI is performance critical and it's rather large, so it was
> defaulted to -Os long before the rest of the kernel. It's not
> a hard requirement, but a generally good idea.

Wrong wording on my part when I wrote "hard requirement".
I should have said "justified requirement" which you with the above
have proved it is.

Thanks,
	Sam
