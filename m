Return-Path: <linux-kernel-owner+w=401wt.eu-S1754800AbZGFG4q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754800AbZGFG4q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jul 2009 02:56:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752654AbZGFG4i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 6 Jul 2009 02:56:38 -0400
Received: from gra-lx1.iram.es ([150.214.224.41]:49349 "EHLO gra-lx1.iram.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752432AbZGFG4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jul 2009 02:56:38 -0400
Date: Mon, 6 Jul 2009 08:56:27 +0200
From: Gabriel Paubert <paubert@iram.es>
To: Andreas Schwab <schwab@linux-m68k.org>
Cc: Brad Boyer <flar@allandria.com>, gcc-help@gcc.gnu.org,
       linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org,
       kernel mailz <kernelmailz@googlemail.com>
Subject: Re: Inline assembly queries [2]
Message-ID: <20090706065627.GA12499@iram.es>
References: <abe8a1fd0907022344k2eb9874ejdbda3209a7cadf40@mail.gmail.com> <20090703174031.GA12410@cynthia.pants.nu> <m23a9deb87.fsf@igel.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m23a9deb87.fsf@igel.home>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 03, 2009 at 10:57:12PM +0200, Andreas Schwab wrote:
> Brad Boyer <flar@allandria.com> writes:
> 
> > On Fri, Jul 03, 2009 at 12:14:41PM +0530, kernel mailz wrote:
> >> b. using m or Z  with a memory address. I tried replacing m/Z but no change
> >> Is there some guideline ?
> >> gcc documentation says Z is obsolete. Is m/Z replaceable ?
> >
> > No idea. I don't remember ever seeing 'Z' used in anything. Maybe somebody
> > else remembers what it used to mean.
> 
> The 'Z' constraint is required for a memory operand for insns that don't
> have an update form (which would be selected by the %U modifier).  

Hmmm, I believed that it was for instructions that only have an indexed
form (all Altivec, byte reverse, and l?arx/st?cx for atomic operations).

Of course none of these instructions have an update form, but they don't
have an offset encoded in the instruction either.

	Gabriel
