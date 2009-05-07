Return-Path: <linux-kernel-owner+w=401wt.eu-S1762692AbZEGU73@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762692AbZEGU73 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 May 2009 16:59:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754923AbZEGU7S
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 May 2009 16:59:18 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43338 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753082AbZEGU7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 May 2009 16:59:18 -0400
Date: Thu, 7 May 2009 13:52:27 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: mingo@elte.hu, greg@kroah.com, norsk5@yahoo.com, tglx@linutronix.de,
       hpa@zytor.com, mchehab@redhat.com, aris@redhat.com, edt@aei.ca,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/21 v3] amd64_edac: EDAC module for AMD64
Message-Id: <20090507135227.abbbc7dc.akpm@linux-foundation.org>
In-Reply-To: <20090507143807.GA15923@aftab>
References: <1241704183-29223-1-git-send-email-borislav.petkov@amd.com>
	<20090507142724.GM481@elte.hu>
	<20090507143807.GA15923@aftab>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 May 2009 16:38:07 +0200
Borislav Petkov <borislav.petkov@amd.com> wrote:

> Hi,
> 
> On Thu, May 07, 2009 at 04:27:24PM +0200, Ingo Molnar wrote:
> > Regarding workflow, the arch/x86 bits look good to me now, so you've 
> > got my Acked-by for that.
> 
> Cool, thanks.
> 
> Does that mean you're going to pick that one or...
> 
> > Most of the EDAC patches are hosted in 
> > -mm, so we could carry them in the x86 tree separately as well and 
> > export it to linux-next so that -mm will have it automatically.
> 
> is the bunch going through Andrew as a whole?
> 

I could.  But there's negligible overlap with other EDAC work so we
might as well merge this via IngoTrees or directly from your tree.

