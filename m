Return-Path: <linux-kernel-owner+w=401wt.eu-S1756160AbZA2BCr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160AbZA2BCr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2009 20:02:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752009AbZA2BCi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Jan 2009 20:02:38 -0500
Received: from gw.infinisim.com ([70.143.7.121]:38102 "EHLO mail.infinisim.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751522AbZA2BCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2009 20:02:37 -0500
Subject: Re: [Bugme-new] [Bug 12564] New: poor performance while
	preprocessing source code
From: Steven Patrick <steven@ngls.net>
To: Jeff Layton <jlayton@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       bugme-daemon@bugzilla.kernel.org, linux-nfs@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20090128170506.37161fb6@tleilax.poochiereds.net>
References: <bug-12564-10286@http.bugzilla.kernel.org/>
	 <20090128132942.c957a199.akpm@linux-foundation.org>
	 <20090128170506.37161fb6@tleilax.poochiereds.net>
Date: Wed, 28 Jan 2009 17:02:36 -0800
Message-Id: <1233190956.21519.13.camel@bluishred.int.infinisim.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-28 at 17:05 -0500, Jeff Layton wrote:
> 
> It's a pretty small patch. The obvious question is: "What mount
> options
> are you using on your NFS mounts?"
> 

  Well, I didn't think that I was using any NFS mounts.
But, it turns out I was in a way.  Apparently, amd does its top
level mounts with noac.  So, where this (using an automounted path):
    cd /h/spo/work
    make -j 5
would be slow.  This (using a non-automounted path):
    cd /home/spo/work
    make -j 5
showed the faster performance I was expecting.
  I will mark my bug as invalid and decide what, if anything,
I want to do about amd.
  Thanks for pointing me in the right direction.

Steven


