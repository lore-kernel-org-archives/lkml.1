Return-Path: <linux-kernel-owner+w=401wt.eu-S1753533AbYCLOra@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753533AbYCLOra (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2008 10:47:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751346AbYCLOrX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Mar 2008 10:47:23 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:53813 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751333AbYCLOrX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2008 10:47:23 -0400
Date: Wed, 12 Mar 2008 10:47:01 -0400
From: Theodore Tso <tytso@mit.edu>
To: David Newall <davidn@davidnewall.com>
Cc: Jiri Kosina <jkosina@suse.cz>, "Fred ." <eldmannen@gmail.com>,
       linux-kernel@vger.kernel.org
Subject: Re: Keys get stuck
Message-ID: <20080312144701.GZ15804@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	David Newall <davidn@davidnewall.com>,
	Jiri Kosina <jkosina@suse.cz>, "Fred ." <eldmannen@gmail.com>,
	linux-kernel@vger.kernel.org
References: <f188924b0803111632h3c122ec7x1be171edd0884dee@mail.gmail.com> <Pine.LNX.4.64.0803121131200.7266@twin.jikos.cz> <47D7B428.6010804@davidnewall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <47D7B428.6010804@davidnewall.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2008 at 09:14:56PM +1030, David Newall wrote:
> It should be said that X implements auto-repeat out of necessity.  While
> the kernel can report key down and up events, its further interpretation
> of those events is not appropriate.  Many combinations of events are
> possible, such as keyboard plus mouse, and this precludes the kernel
> from providing a full interpretation.  It would be wrong for it to even
> try.  X is the proper place to implement auto-repeat for X.

The problem is that under heavy load the auto-repeat problem is real;
I've seen it as well, and it means that I've started to try to avoid
"make -j4" since that's a great way to trigger it.

						- Ted
