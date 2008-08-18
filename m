Return-Path: <linux-kernel-owner+w=401wt.eu-S1753731AbYHROZn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731AbYHROZn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 10:25:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752623AbYHROZd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 10:25:33 -0400
Received: from www.church-of-our-saviour.ORG ([69.25.196.31]:51519 "EHLO
	thunker.thunk.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752530AbYHROZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 10:25:32 -0400
Date: Mon, 18 Aug 2008 10:25:11 -0400
From: Theodore Tso <tytso@mit.edu>
To: tvrtko.ursulin@sophos.com
Cc: david@lang.hm, davecb@sun.com, Adrian Bunk <bunk@kernel.org>,
       Peter Dolding <oiaohm@gmail.com>, rmeijer@xs4all.nl,
       Mihai Don??u <mdontu@bitdefender.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, linux-security-module@vger.kernel.org,
       malware-list-bounces@dmesg.printk.net,
       Casey Schaufler <casey@schaufler-ca.com>, Pavel Machek <pavel@suse.cz>,
       capibara@xs4all.nl, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [malware-list] scanner interface proposal was: [TALPA] Intro
	to a linux interface for on access scanning
Message-ID: <20080818142511.GC8184@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>, tvrtko.ursulin@sophos.com,
	david@lang.hm, davecb@sun.com, Adrian Bunk <bunk@kernel.org>,
	Peter Dolding <oiaohm@gmail.com>, rmeijer@xs4all.nl,
	Mihai Don??u <mdontu@bitdefender.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	malware-list@lists.printk.net,
	linux-security-module@vger.kernel.org,
	malware-list-bounces@dmesg.printk.net,
	Casey Schaufler <casey@schaufler-ca.com>,
	Pavel Machek <pavel@suse.cz>, capibara@xs4all.nl,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Arjan van de Ven <arjan@infradead.org>
References: <alpine.DEB.1.10.0808180444390.12859@asgard.lang.hm> <20080818131628.1C2A22FE82F@pmx1.sophos.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080818131628.1C2A22FE82F@pmx1.sophos.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 18, 2008 at 02:15:24PM +0100, tvrtko.ursulin@sophos.com wrote:
> Then there is still a question of who allows some binary to declare itself 
> exempt. If that decision was a mistake, or it gets compromised security 
> will be off. A very powerful mechanism which must not be easily 
> accessible.  With a good cache your worries go away even without a scheme 
> like this.

I have one word for you --- bittorrent.  If you are downloading a very
large torrent (say approximately a gigabyte), and it contains many
pdf's that are say a few megabytes a piece, and things are coming in
tribbles, having either a indexing scanner or an AV scanner wake up
and rescan the file from scratch each time a tiny piece of the pdf
comes in is going to eat your machine alive....

						- Ted
