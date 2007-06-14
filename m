Return-Path: <linux-kernel-owner+w=401wt.eu-S1756694AbXFNWVW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756694AbXFNWVW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2007 18:21:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751907AbXFNWVK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Jun 2007 18:21:10 -0400
Received: from DELFT.AURA.CS.CMU.EDU ([128.2.206.88]:46592 "EHLO
	delft.aura.cs.cmu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751779AbXFNWVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2007 18:21:09 -0400
Date: Thu, 14 Jun 2007 18:21:07 -0400
To: David Schwartz <davids@webmaster.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Dual-Licensing Linux Kernel with GPL V2 and GPL V3
Message-ID: <20070614222107.GQ9614@delft.aura.cs.cmu.edu>
Mail-Followup-To: David Schwartz <davids@webmaster.com>,
	linux-kernel@vger.kernel.org
References: <20070613180953.GA18512@delft.aura.cs.cmu.edu> <MDEHLPKNGKAHNMBLJOLKEEFCEJAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKEEFCEJAC.davids@webmaster.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
From: Jan Harkes <jaharkes@cs.cmu.edu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 14, 2007 at 12:28:34PM -0700, David Schwartz wrote:
> > The GPL applies to "the Program" which in this case is the Linux kernel
> > as a whole and it in fact does indicate a specific version. All code
> > submitted and included in this program has has been submitted with the
> > understanding that the work as a whole is specifically licensed as
> > GPLv2. Some authors have granted additional rights, such as dual BSD/GPL
> > or GPLv2 and later and explicitly added such a notice.
> 
> Since the Linux kernel as a whole does not have a single author, it is
> impossible to license it as a whole. Nobody has the authority to do that.
> (The GPL is not a copyright assignment type license.)
> 
> Fortunately, the GPL clears this up:
> 
> "Each time you redistribute the Program (or any work based on the
> Program), the recipient automatically receives a license from the
> original licensor to copy, distribute or modify the Program subject to
> these terms and conditions.  You may not impose any further
> restrictions on the recipients' exercise of the rights granted herein.
> You are not responsible for enforcing compliance by third parties to
> this License."
> 
> Linus cannot impose any further restrictions on the recipients' exercise of
> the rights granted.
> 
> When you download a copy of the Linux kernel, you do not receive one license
> because nobody could grant you one license. You receive a logically separate
> license from each original licensor. You receive from Linus only a license
> to his contributions.
> 
> Note that you cannot take a GPLv2+ work and redistribute it as GPLv3 only.
> You can license your contributions as GPLv3 only of course. However, each
> recipient still receives a GPLv2+ license to the parts that were originally
> licensed that way. The people you distribute the work from receive licenses
> from the original licensors to those parts, and you have no right to modify
> that license. (See GPL section 6, quoted above.)

You have a good point. It can be argued that contributions before
2.4.0-test8 were in fact GPLv2+, but anything after that point has
clearly been contributed as GPLv2 only.

So now we have a bunch of pre-2.4.0-test8 code that may possibly be v2+
and files that explicitly state v2+ in their boiler plate. However many
of these files may have had additional contributions from other authors
which (unless otherwise specified) were GPLv2-only. And because v2 and
v3 are incompatible, all those files with v2-only contributions will
become v2-only when version 3 is released. Of course it may be that all
those copyright owners do not mind re-releasing their copyrighted code
as v2+, but they will have to be contacted.

Several maintainers did pay attention to such details. I once submitted
a patch that among others touched reiserfs, and I promptly got a
friendly email from Hans asking me to sign off any rights he needed to
re-release the related code under a different license, so he made sure
the combined work wouldn't end up GPLv2 only.

Jan

