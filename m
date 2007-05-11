Return-Path: <linux-kernel-owner+w=401wt.eu-S966734AbXEKTyt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966734AbXEKTyt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 15:54:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S966457AbXEKTrd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 15:47:33 -0400
Received: from mx1.redhat.com ([66.187.233.31]:39316 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966484AbXEKTrc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 15:47:32 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
From: Roland McGrath <roland@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
X-Fcc: ~/Mail/linus
Cc: Andi Kleen <ak@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>, Chris Wright <chrisw@sous-sol.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Andrew Morton <akpm@linux-foundation.com>
Subject: Re: [patch 2/7] use elfnote.h to generate vsyscall notes.
In-Reply-To: Jeremy Fitzhardinge's message of  Thursday, 10 May 2007 16:57:10 -0700 <20070511000026.673875000@goop.org>
X-Zippy-Says: Hmmm...  a PINHEAD, during an EARTHQUAKE, encounters an ALL-MIDGET
   FIDDLE ORCHESTRA...  ha..  ha..
Message-Id: <20070511194725.E37E51F8512@magilla.localdomain>
Date: Fri, 11 May 2007 12:47:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

I used .balign because .align has inconsistent meaning on some platforms
(matches .p2align instead of .balign).  Using .align in a
machine-independent file seems questionable.


Thanks,
Roland
