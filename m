Return-Path: <linux-kernel-owner+w=401wt.eu-S1757292AbZGGNqr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292AbZGGNqr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 09:46:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754729AbZGGNqg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 09:46:36 -0400
Received: from gra-lx1.iram.es ([150.214.224.41]:58727 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753697AbZGGNqf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 09:46:35 -0400
Date: Tue, 7 Jul 2009 15:46:22 +0200
From: Gabriel Paubert <paubert@iram.es>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Brad Boyer <flar@allandria.com>, gcc-help@gcc.gnu.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       kernel mailz <kernelmailz@googlemail.com>
Subject: Re: Inline assembly queries [2]
Message-ID: <20090707134622.GB13444@iram.es>
References: <abe8a1fd0907022344k2eb9874ejdbda3209a7cadf40@mail.gmail.com> <20090703174031.GA12410@cynthia.pants.nu> <m23a9deb87.fsf@igel.home> <20090706065627.GA12499@iram.es> <m37hykis4d.fsf@hase.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m37hykis4d.fsf@hase.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 07, 2009 at 02:40:02PM +0200, Andreas Schwab wrote:
> Gabriel Paubert <paubert@iram.es> writes:
> 
> > On Fri, Jul 03, 2009 at 10:57:12PM +0200, Andreas Schwab wrote:
> >> The 'Z' constraint is required for a memory operand for insns that don't
> >> have an update form (which would be selected by the %U modifier).  
> >
> > Hmmm, I believed that it was for instructions that only have an indexed
> > form (all Altivec, byte reverse, and l?arx/st?cx for atomic operations).
> >
> > Of course none of these instructions have an update form, but they don't
> > have an offset encoded in the instruction either.
> 
> Yes, you are right.  IIRC there are either all u/x/ux forms or only the
> x form.

AFAIR IBM (probably) managed to screw up by making an exception for lwa: 
lwa, lwax and lwaux exist, but not lwau!

	Gabriel
