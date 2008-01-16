Return-Path: <linux-kernel-owner+w=401wt.eu-S1754222AbYAPDGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbYAPDGE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 22:06:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754829AbYAPDFx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 22:05:53 -0500
Received: from mx1.redhat.com ([66.187.233.31]:58404 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752586AbYAPDFv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 22:05:51 -0500
Date: Tue, 15 Jan 2008 22:05:28 -0500
From: Rik van Riel <riel@redhat.com>
To: "Daniel Phillips" <phillips@google.com>
Cc: "Pavel Machek" <pavel@ucw.cz>, "Alan Cox" <alan@lxorguk.ukuu.org.uk>,
       "Theodore Tso" <tytso@mit.edu>, "Al Boldi" <a1426z@gawab.com>,
       "Valerie Henson" <val.henson@gmail.com>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch] document ext3 requirements (was Re: [RFD] Incremental
 fsck)
Message-ID: <20080115220528.139da08a@bree.surriel.com>
In-Reply-To: <4d47a5d10801151744t378ecdcbj1c326181b4360452@mail.gmail.com>
References: <200801090022.55589.a1426z@gawab.com>
	<200801090740.12989.a1426z@gawab.com>
	<70b6f0bf0801082345vf57951ey642e35c3d6e5194f@mail.gmail.com>
	<200801091452.14890.a1426z@gawab.com>
	<20080112145140.GB6751@mit.edu>
	<20080113171916.GB4132@ucw.cz>
	<20080113174125.5f39ac64@lxorguk.ukuu.org.uk>
	<20080115201653.GA5639@elf.ucw.cz>
	<4d47a5d10801151744t378ecdcbj1c326181b4360452@mail.gmail.com>
Organization: Red Hat, Inc.
X-Mailer: Claws Mail 3.0.2 (GTK+ 2.10.4; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jan 2008 20:44:38 -0500
"Daniel Phillips" <phillips@google.com> wrote:

> Along with this effort, could you let me know if the world actually
> cares about online fsck?  Now we know how to do it I think, but is it
> worth the effort.

With a filesystem that is compartmentalized and checksums metadata,
I believe that an online fsck is absolutely worth having.

Instead of the filesystem resorting to mounting the whole volume
read-only on certain errors, part of the filesystem can be offlined
while an fsck runs.  This could even be done automatically in many
situations.

-- 
All rights reversed.
