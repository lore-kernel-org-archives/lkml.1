Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbZEDTbg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbZEDTbg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 May 2009 15:31:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752089AbZEDTb0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 May 2009 15:31:26 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:47119 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbZEDTb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 May 2009 15:31:26 -0400
Date: Mon, 4 May 2009 21:33:36 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: "H. Peter Anvin" <hpa@linux.intel.com>,
       Andreas Schwab <schwab@linux-m68k.org>
Cc: Andreas Schwab <schwab@linux-m68k.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-arch@vger.kernel.org
Subject: Re: "N" symbols and System.map
Message-ID: <20090504193336.GA10453@uranus.ravnborg.org>
References: <49FB7692.2000508@linux.intel.com> <m2preso1wl.fsf@igel.home> <20090501232149.GA28888@uranus.ravnborg.org> <49FB8D27.3000305@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49FB8D27.3000305@linux.intel.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 01, 2009 at 05:00:39PM -0700, H. Peter Anvin wrote:
> Sam Ravnborg wrote:
> >On Sat, May 02, 2009 at 01:10:18AM +0200, Andreas Schwab wrote:
> >>"H. Peter Anvin" <hpa@linux.intel.com> writes:
> >>
> >>>right now, we filter out symbols that nm tag N, meaning "debugging
> >>>symbols", from System.map.  However, at least on x86, the 
> >>>linker-generated
> >>>symbol _end is tagged N, and in fact is the only N in the entire image.
> >>>
> >>>Are there other architectures which would suffer if N were included in
> >>>System.map, or would that be a reasonable thing to do?
> >>There should not be any N symbols unless you are using stabs debugging.
> >
> >We have in vmlinux:
> >        .end : AT(ADDR(.end) - LOAD_OFFSET) {
> >                _end = .;
> >        }
> >
> >
> >And I see:
> >c1834000 N _end
> >
> >This is the _only_ 'N' symbol in my vmlinux.
> >
> 
> Yup, this is what happens.  I don't know why the linker does this, and 
> if there is a way around it.

Andreas - can you explain what is happning here?
I can include 'N' symbols in System.map - but I have not yet reached
a level of understanding that make me go and do it.

	Sam
