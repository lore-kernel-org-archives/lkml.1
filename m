Return-Path: <linux-kernel-owner+w=401wt.eu-S1759444AbYEMRtS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759444AbYEMRtS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:49:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755331AbYEMRtD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:49:03 -0400
Received: from extu-mxob-2.symantec.com ([216.10.194.135]:57573 "EHLO
	extu-mxob-2.symantec.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753714AbYEMRtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:49:01 -0400
Date: Tue, 13 May 2008 18:47:33 +0100 (BST)
From: Hugh Dickins <hugh@veritas.com>
X-X-Sender: hugh@blonde.site
To: "Carlos R. Mafra" <crmafra2@gmail.com>
cc: Glauber Costa <gcosta@redhat.com>, Glauber Costa <glommer@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix app crashes after SMP resume
In-Reply-To: <20080513172455.GA11774@beyonder.ift.unesp.br>
Message-ID: <Pine.LNX.4.64.0805131846050.19931@blonde.site>
References: <Pine.LNX.4.64.0805131420030.5781@blonde.site>
 <20080513172455.GA11774@beyonder.ift.unesp.br>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 May 2008, Carlos R. Mafra wrote:
> On Tue 13.May'08 at 14:26:57 +0100, Hugh Dickins wrote:
> > After resume on a 2cpu laptop, kernel builds collapse with a sed hang,
> > sh or make segfault (often on 20295564), real-time signal to cc1 etc.
> > [...] 
> > Signed-off-by: Hugh Dickins <hugh@veritas.com>
> > ---
> 
> I've tested it twice already in my P4 desktop (where the problem was
> very frequent after "echo standby > /sys/power/state") and the
> patch really fixed it!!

Great, thanks a lot for sharing the problem and reporting back, Carlos.

Hugh
