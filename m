Return-Path: <linux-kernel-owner+w=401wt.eu-S1757512AbYC1Szt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757512AbYC1Szt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2008 14:55:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756730AbYC1Szg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Mar 2008 14:55:36 -0400
Received: from relay2.sgi.com ([192.48.171.30]:52737 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756518AbYC1Szf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2008 14:55:35 -0400
Date: Fri, 28 Mar 2008 11:53:27 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Andrew Morton <akpm@linux-foundation.org>
cc: Linus Torvalds <torvalds@linux-foundation.org>, penberg@cs.helsinki.fi,
       rjw@sisk.pl, pstaszewski@artcom.pl, linux-kernel@vger.kernel.org,
       bunk@kernel.org, protasnb@gmail.com
Subject: Re: 2.6.25-rc7-git2: Reported regressions from 2.6.24
In-Reply-To: <20080328114734.13607172.akpm@linux-foundation.org>
Message-ID: <Pine.LNX.4.64.0803281152440.17920@schroedinger.engr.sgi.com>
References: <200803272353.51901.rjw@sisk.pl>
 <alpine.LFD.1.00.0803271859280.14670@woody.linux-foundation.org>
 <Pine.LNX.4.64.0803272002090.11979@schroedinger.engr.sgi.com>
 <alpine.LFD.1.00.0803272050290.14670@woody.linux-foundation.org>
 <84144f020803281015s60370d9dpec0913c33004b6c2@mail.gmail.com>
 <alpine.LFD.1.00.0803281017500.14670@woody.linux-foundation.org>
 <84144f020803281108o178bf62cp48dcd4f43ec59b74@mail.gmail.com>
 <alpine.LFD.1.00.0803281116460.14670@woody.linux-foundation.org>
 <20080328114734.13607172.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Mar 2008, Andrew Morton wrote:

> I believe http://bugzilla.kernel.org/show_bug.cgi?id=10318 is a false
> positive.  There's no way in which networking will be using highmem pages
> here, so it won't be taking the KM_USER0 kmap slot, so there's no point in
> performing these checks.

Reviewed-by: Christoph Lameter <clameter@sgi.com>
