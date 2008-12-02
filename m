Return-Path: <linux-kernel-owner+w=401wt.eu-S1754833AbYLBUgh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754833AbYLBUgh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2008 15:36:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752371AbYLBUfK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 2 Dec 2008 15:35:10 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49458 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751644AbYLBUfI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2008 15:35:08 -0500
Message-ID: <49359AAF.6010803@redhat.com>
Date: Tue, 02 Dec 2008 14:29:35 -0600
From: Eric Sandeen <sandeen@redhat.com>
User-Agent: Thunderbird 2.0.0.18 (Macintosh/20081105)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: roel kluin <roel.kluin@gmail.com>, sct@redhat.com, adilger@sun.com,
       linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ext3: also fix loop in do_split()
References: <49310E1A.60105@gmail.com> <20081202120751.8b0226ca.akpm@linux-foundation.org>
In-Reply-To: <20081202120751.8b0226ca.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton wrote:

> A local variable called `i' should always have signed type.  In fact,
> it should have `int' type.  Doing
> 
> 	unsigned i;
> 
> is an act of insane vandalism, punishable by spending five additional
> years coding in fortran.
> 
> I suggest you fix this by giving `i' the type God intended, or by
> making it unsigned and then renaming it to something which is not
> intended to trick programmers and reviewers.
> 
> Sheesh.

/me hangs head in shame, and points feebly but only halfheartedly at the
other people who reviewed the change when it originally went in... I
have no idea what I was thinking.  Sorry.  Please don't make me go back
to Fortran.

-Eric
