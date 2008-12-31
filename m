Return-Path: <linux-kernel-owner+w=401wt.eu-S1756133AbYLaPdU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756133AbYLaPdU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Dec 2008 10:33:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754906AbYLaPdI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 31 Dec 2008 10:33:08 -0500
Received: from pfepa.post.tele.dk ([195.41.46.235]:35167 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbYLaPdH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Dec 2008 10:33:07 -0500
Date: Wed, 31 Dec 2008 16:34:41 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>
Subject: Re: [PATCH 01/15] ACPI: create kernel/acpi/
Message-ID: <20081231153441.GA3475@uranus.ravnborg.org>
References: <1230720725-9376-1-git-send-email-lenb@kernel.org> <526647e1bb69fd3248558fce365bb1fbfb226ccd.1230719795.git.len.brown@intel.com> <20081231133901.GB2388@uranus.ravnborg.org> <87bpusv31n.fsf@basil.nowhere.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87bpusv31n.fsf@basil.nowhere.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 31, 2008 at 03:21:08PM +0100, Andi Kleen wrote:
> Sam Ravnborg <sam@ravnborg.org> writes:
> > Why is ACPI_CFLAGS exported?
> >> +ACPI_CFLAGS	:= -Os
> >> +
> >> +ifdef CONFIG_ACPI_DEBUG
> >> +  ACPI_CFLAGS	+= -DACPI_DEBUG_OUTPUT
> >> +endif
> >> +
> >> +EXTRA_CFLAGS	+= $(ACPI_CFLAGS)
> > A better way:
> >
> > ccflags-$(CONFIG_ACPI_DEBUG) := -DACPI_DEBUG_OUTPUT
> 
> Surely s/:=/+=/ ?

Only if ccflags-y is assigned earlier in the same file
otherwise it does not matter.

	Sam
