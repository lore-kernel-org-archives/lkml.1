Return-Path: <linux-kernel-owner+w=401wt.eu-S1755533AbZBKCpf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755533AbZBKCpf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Feb 2009 21:45:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752862AbZBKCp1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Feb 2009 21:45:27 -0500
Received: from ns2.suse.de ([195.135.220.15]:42533 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752451AbZBKCp1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Feb 2009 21:45:27 -0500
Date: Tue, 10 Feb 2009 18:40:47 -0800
From: Greg KH <gregkh@suse.de>
To: Keith Packard <keithp@keithp.com>
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
       alan@lxorguk.ukuu.org.uk, Eric Anholt <eric@anholt.net>,
       Dave Airlie <airlied@redhat.com>
Subject: Re: [patch 05/56] agp/intel: Reduce extraneous PCI posting reads
	during init
Message-ID: <20090211024047.GA16565@suse.de>
References: <20090211001439.873435357@mini.kroah.org> <20090211002422.GF14660@kroah.com> <1234318422.11303.51.camel@aiko.keithp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1234318422.11303.51.camel@aiko.keithp.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 10, 2009 at 06:13:42PM -0800, Keith Packard wrote:
> On Tue, 2009-02-10 at 16:24 -0800, Greg KH wrote:
> > plain text document attachment
> > (agp-intel-reduce-extraneous-pci-posting-reads-during-init.patch)
> > 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> 
> Not exactly a critical fix; more like a janitorial change, and only in
> the start-up code path.

People care about the speed of things in the start-up code path :)

thanks,

greg k-h
