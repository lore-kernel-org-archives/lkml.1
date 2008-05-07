Return-Path: <linux-kernel-owner+w=401wt.eu-S934040AbYEGWb4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934040AbYEGWb4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2008 18:31:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933098AbYEGWbQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 May 2008 18:31:16 -0400
Received: from sj-iport-6.cisco.com ([171.71.176.117]:54634 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765381AbYEGWbL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2008 18:31:11 -0400
From: Roland Dreier <rdreier@cisco.com>
To: Andrea Arcangeli <andrea@qumranet.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, npiggin@suse.de,
       chrisw@redhat.com, rusty@rustcorp.com.au, a.p.zijlstra@chello.nl,
       marcelo@kvack.org, kvm-devel@lists.sourceforge.net,
       kanojsarcar@yahoo.com, steiner@sgi.com, linux-kernel@vger.kernel.org,
       avi@qumranet.com, aliguori@us.ibm.com, paulmck@us.ibm.com,
       linux-mm@kvack.org, holt@sgi.com, general@lists.openfabrics.org,
       hugh@veritas.com, Andrew Morton <akpm@linux-foundation.org>,
       dada1@cosmosbay.com, clameter@sgi.com
Subject: Re: [ofa-general] Re: [PATCH 01 of 11] mmu-notifier-core
References: <patchbomb.1210170950@duo.random>
	<e20917dcc8284b6a07cf.1210170951@duo.random>
	<20080507130528.adfd154c.akpm@linux-foundation.org>
	<alpine.LFD.1.10.0805071324570.3024@woody.linux-foundation.org>
	<20080507215840.GB8276@duo.random>
	<alpine.LFD.1.10.0805071509270.3024@woody.linux-foundation.org>
	<20080507222758.GD8276@duo.random>
X-Message-Flag: Warning: May contain useful information
Date: Wed, 07 May 2008 15:31:08 -0700
In-Reply-To: <20080507222758.GD8276@duo.random> (Andrea Arcangeli's message of
	"Thu, 8 May 2008 00:27:58 +0200")
Message-ID: <adaej8du4pf.fsf@cisco.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-OriginalArrivalTime: 07 May 2008 22:31:09.0197 (UTC) FILETIME=[0BEEC3D0:01C8B092]
Authentication-Results: sj-dkim-1; header.From=rdreier@cisco.com; dkim=pass (
	sig from cisco.com/sjdkim1004 verified; ); 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > I rechecked and I guarantee that the patches where Christoph isn't
 > listed are developed by myself and he didn't write a single line on
 > them. In any case I expect Christoph to review (he's CCed) and to
 > point me to any attribution error. The only mistake I did once in that
 > area was to give too _few_ attribution to myself and he asked me to
 > add myself in the signed-off so I added myself by Christoph own
 > request, but be sure I didn't remove him!

I think the point you're missing is that any patches written by
Christoph need a line like

From: Christoph Lameter <clameter@sgi.com>

at the top of the body so that Christoph becomes the author when it is
committed into git.  The Signed-off-by: line needs to be preserved too
of course, but it is not sufficient by itself.

 - R.
