Return-Path: <linux-kernel-owner+w=401wt.eu-S1752709AbYBKCMu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752709AbYBKCMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Feb 2008 21:12:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751357AbYBKCMl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Feb 2008 21:12:41 -0500
Received: from c60.cesmail.net ([216.154.195.49]:10841 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299AbYBKCMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Feb 2008 21:12:40 -0500
Subject: Re: [RFC PATCH v2] x86: explicit call to mmiotrace in
	do_page_fault()
From: Pavel Roskin <proski@gnu.org>
To: Pekka Paalanen <pq@iki.fi>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Jan Beulich <jbeulich@novell.com>,
       Ingo Molnar <mingo@elte.hu>, Christoph Hellwig <hch@infradead.org>,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <20080210200521.6278d39f@daedalus.pq.iki.fi>
References: <1201660453.8837.13.camel@brick>
	 <20080130200827.322c4f7d@daedalus.pq.iki.fi>
	 <20080131150746.GB11996@elte.hu>
	 <20080131180253.6c007852@daedalus.pq.iki.fi>
	 <20080131081507.5edcde10@laptopd505.fenrus.org>
	 <20080203085522.2b63e15b@daedalus.pq.iki.fi>
	 <20080203070321.GA8293@elte.hu>
	 <20080205222807.7b35ef2b@daedalus.pq.iki.fi>
	 <20080205223958.2cab8ce3@daedalus.pq.iki.fi>
	 <20080207125327.GB27234@elte.hu> <20080207125622.GA7111@infradead.org>
	 <20080209195255.584d4157@daedalus.pq.iki.fi>
	 <1202582370.16505.6.camel@lappy>
	 <20080210200521.6278d39f@daedalus.pq.iki.fi>
Content-Type: text/plain
Date: Sun, 10 Feb 2008 21:12:38 -0500
Message-Id: <1202695958.24474.22.camel@dv>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.3 (2.12.3-1.fc8) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2008-02-10 at 20:05 +0200, Pekka Paalanen wrote:

> Sorry Jan and Pavel, I forgot to CC you in the first go of this
> patch. If this makes it into mainline, I don't think it will be left
> there for many kernel versions. I plan to make kmmio.h as the API towards
> modules in the future, and the page fault callback will "disappear".
> I think madwifi could use just fine the kmmio.h functions, if it
> works basically just like mmiotrace.

In fact, the tracing version of MadWifi has a directory called mmiotrace
with the files lifted from nouveau.  I guess if will just stay in sync
with the upstream.

Many thanks for pushing it into the kernel.

-- 
Regards,
Pavel Roskin
