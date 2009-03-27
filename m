Return-Path: <linux-kernel-owner+w=401wt.eu-S1760018AbZC0Di2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760018AbZC0Di2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Mar 2009 23:38:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757769AbZC0DiT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Mar 2009 23:38:19 -0400
Received: from mx2.redhat.com ([66.187.237.31]:38865 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757623AbZC0DiS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Mar 2009 23:38:18 -0400
Date: Thu, 26 Mar 2009 23:36:55 -0400
From: Dave Jones <davej@redhat.com>
To: David Rees <drees76@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Theodore Tso <tytso@mit.edu>, Jesper Krogh <jesper@krogh.cc>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.29
Message-ID: <20090327033654.GA21857@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	David Rees <drees76@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Theodore Tso <tytso@mit.edu>, Jesper Krogh <jesper@krogh.cc>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20090325183011.GN32307@mit.edu> <alpine.LFD.2.00.0903251139260.3032@localhost.localdomain> <20090325220530.GR32307@mit.edu> <alpine.LFD.2.00.0903251622420.3032@localhost.localdomain> <20090326171148.9bf8f1ec.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261723250.3994@localhost.localdomain> <20090326174704.cd36bf7b.akpm@linux-foundation.org> <alpine.LFD.2.00.0903261752110.3994@localhost.localdomain> <20090326182519.d576d703.akpm@linux-foundation.org> <72dbd3150903261921k7cf728ebhf331e9965630be7e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <72dbd3150903261921k7cf728ebhf331e9965630be7e@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 26, 2009 at 07:21:08PM -0700, David Rees wrote:
 
 > * Mon Mar 23 2009 xx <xx@xx.xx> 2.6.29-2
 >  - Change default swappiness setting from 60 to 30.
 > 
 > * Thu Mar 19 2009 xx <xx@xx.xx> 2.6.29-0.66.rc8.git4
 >  - Raise default vm dirty data limits from 5/10 to 10/20 percent.
 > 
 > Why are the going in the kernel package instead of /etc/sysctl.conf?

At least in part, because rpm sucks.
If a user has editted /etc/sysctl.conf, upgrading the initscripts package
won't change that file.

	Dave

