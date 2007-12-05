Return-Path: <linux-kernel-owner+w=401wt.eu-S1753398AbXLEOu1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753398AbXLEOu1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2007 09:50:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751922AbXLEOuT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Dec 2007 09:50:19 -0500
Received: from THUNK.ORG ([69.25.196.29]:44961 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751474AbXLEOuS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2007 09:50:18 -0500
Date: Wed, 5 Dec 2007 09:49:34 -0500
From: Theodore Tso <tytso@mit.edu>
To: Mike McGrath <mmcgrath@redhat.com>
Cc: Matt Mackall <mpm@selenic.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Ray Lee <ray@madrabbit.org>, Adrian Bunk <bunk@kernel.org>,
       Marc Haber <mh+linux-kernel@zugschlus.de>, linux-kernel@vger.kernel.org
Subject: Re: Why does reading from /dev/urandom deplete entropy so much?
Message-ID: <20071205144934.GL7259@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Mike McGrath <mmcgrath@redhat.com>, Matt Mackall <mpm@selenic.com>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, Ray Lee <ray@madrabbit.org>,
	Adrian Bunk <bunk@kernel.org>,
	Marc Haber <mh+linux-kernel@zugschlus.de>,
	linux-kernel@vger.kernel.org
References: <20071204165502.0a8f695e@the-village.bc.nu> <20071204180237.GU19691@waste.org> <20071204195021.GB7259@thunk.org> <20071204204036.484f11ac@the-village.bc.nu> <20071204210827.GE19691@waste.org> <4755C423.60907@redhat.com> <20071204221525.GG19691@waste.org> <4755D350.1080801@redhat.com> <20071204223345.GJ19691@waste.org> <4756B50B.3060100@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4756B50B.3060100@redhat.com>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 05, 2007 at 08:26:19AM -0600, Mike McGrath wrote:
>
> Ok, whats going on here is an issue with how the smolt RPM installs the 
> UUID and how Fedora's Live CD does an install.  It's a complete false alarm 
> on the kernel side, sorry for the confusion.

BTW, You may be better off using "uuidgen -t" to generate the UUID in
the smolt RPM, since that will use 12 bits of randomness from
/dev/random, plus the MAC, address and timestamp.  So even if there is
zero randomness in /dev/random, and the time is January 1, 1970, at
least the MAC will contribute some uniqueness to the UUID.

      	      	   	      	   	      	 - Ted
