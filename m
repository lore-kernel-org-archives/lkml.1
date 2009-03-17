Return-Path: <linux-kernel-owner+w=401wt.eu-S1762464AbZCQAdY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762464AbZCQAdY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Mar 2009 20:33:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754109AbZCQAdN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Mar 2009 20:33:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:56846 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755314AbZCQAdM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Mar 2009 20:33:12 -0400
Date: Mon, 16 Mar 2009 17:28:28 -0700
From: Greg KH <gregkh@suse.de>
To: Prakash Punnoor <prakash@punnoor.de>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Yinghai Lu <yinghai@kernel.org>
Subject: Re: [patch 069/114] PCI: dont enable too many HT MSI mappings
Message-ID: <20090317002828.GA1313@suse.de>
References: <20090314010937.416083662@mini.kroah.org> <20090314011041.598193480@mini.kroah.org> <200903140853.41893.prakash@punnoor.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200903140853.41893.prakash@punnoor.de>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 14, 2009 at 08:53:38AM +0100, Prakash Punnoor wrote:
> On Samstag 14 März 2009 02:10:46 Greg KH wrote:
> > 2.6.28-stable review patch.  If anyone has any objections, please let us
> > know.
> >
> > ------------------
> >
> > From: Yinghai Lu <yinghai@kernel.org>
> >
> > commit 1dec6b054dd1fc780e18b815068bf5677409eb2d upstream.
> 
> You also want to add 
> 
>   commit  7726c3308a92b4a4c3bd059059498fca0e6f8e48
>   commit  6a958d5b28e4a180458e0d319d2e4bb5c4b7da3e
> 
> otherwise this one doesn't help me much - or drop this one completely for a 
> while. To fix my system, 7726c3308a92b4a4c3bd059059498fca0e6f8e48 alone 
> (without 1dec6b054dd1fc780e18b815068bf5677409eb2d) should be enough.

Thanks, I've dropped this for now.

greg k-h
