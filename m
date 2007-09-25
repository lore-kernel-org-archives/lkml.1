Return-Path: <linux-kernel-owner+w=401wt.eu-S1759384AbXIYVTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759384AbXIYVTP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2007 17:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753104AbXIYVS6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 25 Sep 2007 17:18:58 -0400
Received: from mx1.redhat.com ([66.187.233.31]:44241 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752776AbXIYVS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2007 17:18:57 -0400
Date: Tue, 25 Sep 2007 17:17:44 -0400
From: Dave Jones <davej@redhat.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Christoph Hellwig <hch@infradead.org>, Adrian Bunk <bunk@kernel.org>,
       perex@suse.cz, linux-kernel@vger.kernel.org
Subject: Re: [-mm patch] unexport sys_{open,read}
Message-ID: <20070925211744.GM8127@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Arjan van de Ven <arjan@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christoph Hellwig <hch@infradead.org>,
	Adrian Bunk <bunk@kernel.org>, perex@suse.cz,
	linux-kernel@vger.kernel.org
References: <20070909202527.GT3563@stusta.de> <20070909203920.GA11764@infradead.org> <20070909145940.0b41c8a5.akpm@linux-foundation.org> <20070910090808.GA31204@infradead.org> <20070910022324.c69e1897.akpm@linux-foundation.org> <20070910161456.7431312c@laptopd505.fenrus.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070910161456.7431312c@laptopd505.fenrus.org>
User-Agent: Mutt/1.5.14 (2007-02-12)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2007 at 04:14:56PM +0100, Arjan van de Ven wrote:
 
 > Maybe I'm too pessimistic in my assumption that external open module
 > writers don't actually follow mainline closely; and maybe part of me
 > would love for them to follow it closer, so close that they would even
 > consider submitting their driver for it. But sadly from experience...
 > warnings dont' work. Only when things break hard people notice.

We've both done the same job, so it's unsurprising that we share the
same view on this.  A number of times I've had out of tree module
authors complaining to _me_ because "Fedora fucked up my module, it
works fine in $otherdistro"  (ignoring the fact that $otherdistro
is a point release or more behind Fedora).

There's definitly a culture-gap between some out-of-tree module
authors and people who intend from day 1 to get their code merged
into mainline.  The former don't know what happens in mainline
until several distros start moving onto newer kernels, so no amount
of warnings is going to help these people.

	Dave

-- 
http://www.codemonkey.org.uk
