Return-Path: <linux-kernel-owner+w=401wt.eu-S1756741AbYHRSgn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756741AbYHRSgn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 14:36:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754837AbYHRSge
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 14:36:34 -0400
Received: from mx1.redhat.com ([66.187.233.31]:58332 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbYHRSgd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 14:36:33 -0400
Subject: Re: [malware-list] scanner interface proposal
	was:	[TALPA]	Intro	to a linux interface for on access scanning
From: Eric Paris <eparis@redhat.com>
To: david@lang.hm
Cc: tvrtko.ursulin@sophos.com, Theodore Tso <tytso@mit.edu>, davecb@sun.com,
       Adrian Bunk <bunk@kernel.org>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       malware-list@lists.printk.net, Casey Schaufler <casey@schaufler-ca.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Arjan van de Ven <arjan@infradead.org>
In-Reply-To: <alpine.DEB.1.10.0808181107320.15109@asgard.lang.hm>
References: <20080818153212.6A6FD33687F@pmx1.sophos.com>
	 <1219076143.15566.39.camel@localhost.localdomain>
	 <alpine.DEB.1.10.0808181015070.15109@asgard.lang.hm>
	 <1219081154.15566.73.camel@localhost.localdomain>
	 <alpine.DEB.1.10.0808181107320.15109@asgard.lang.hm>
Content-Type: text/plain
Date: Mon, 18 Aug 2008 14:34:12 -0400
Message-Id: <1219084452.15566.90.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 (2.22.3.1-1.fc9) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-08-18 at 11:09 -0700, david@lang.hm wrote:
> if you have multiple things reading from a pipe only one will get any one 
> message, right?

S_ISREG()  ?   We're talking about file scanning not communication
interception.  Arjan strongly wanted me to push this down to read, but I
still planned to not look at lnks, dirs, chars, blocks, fifos and
sockets...

