Return-Path: <linux-kernel-owner+w=401wt.eu-S1761265AbYEMRZg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761265AbYEMRZg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 13:25:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756782AbYEMRZ2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 13:25:28 -0400
Received: from mail.ift.unesp.br ([200.145.46.3]:53082 "EHLO mail.ift.unesp.br"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753622AbYEMRZ2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 13:25:28 -0400
Date: Tue, 13 May 2008 14:24:55 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: Hugh Dickins <hugh@veritas.com>
Cc: Glauber Costa <gcosta@redhat.com>, Glauber Costa <glommer@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       "H. Peter Anvin" <hpa@zytor.com>, "Theodore Ts'o" <tytso@mit.edu>,
       "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: fix app crashes after SMP resume
Message-ID: <20080513172455.GA11774@beyonder.ift.unesp.br>
Mail-Followup-To: Hugh Dickins <hugh@veritas.com>,
	Glauber Costa <gcosta@redhat.com>,
	Glauber Costa <glommer@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
	Theodore Ts'o <tytso@mit.edu>, "Rafael J. Wysocki" <rjw@sisk.pl>,
	linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0805131420030.5781@blonde.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0805131420030.5781@blonde.site>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 13.May'08 at 14:26:57 +0100, Hugh Dickins wrote:
> After resume on a 2cpu laptop, kernel builds collapse with a sed hang,
> sh or make segfault (often on 20295564), real-time signal to cc1 etc.
> [...] 
> Signed-off-by: Hugh Dickins <hugh@veritas.com>
> ---

I've tested it twice already in my P4 desktop (where the problem was
very frequent after "echo standby > /sys/power/state") and the
patch really fixed it!!

