Return-Path: <linux-kernel-owner+w=401wt.eu-S1753237AbYKQNei@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753237AbYKQNei (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2008 08:34:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751894AbYKQNe3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Nov 2008 08:34:29 -0500
Received: from mx2.redhat.com ([66.187.237.31]:49677 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751809AbYKQNe2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2008 08:34:28 -0500
Date: Mon, 17 Nov 2008 11:31:21 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Greg KH <gregkh@suse.de>
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
       alan@lxorguk.ukuu.org.uk, Greg Kroah-Hartman <gregkh@suse.de>,
       Rafael Wysocki <rjw@sisk.pl>
Subject: Re: [patch 25/46] V4L/DVB (9624): CVE-2008-5033: fix OOPS on
 tvaudio when controlling bass/treble
Message-ID: <20081117113121.11bcd0f2@pedra.chehab.org>
In-Reply-To: <20081117071551.GZ29522@kroah.com>
References: <20081117070621.430169021@blue.kroah.org>
	<20081117071551.GZ29522@kroah.com>
Organization: Red Hat
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, 16 Nov 2008 23:15:51 -0800
Greg KH <gregkh@suse.de> wrote:

> 2.6.27-stable review patch.  If anyone has any objections, please let us know.
> 
> ------------------
> 
> From: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> commit 01a1a3cc1e3fbe718bd06a2a5d4d1a2d0fb4d7d9 upstream.
> 
> This bug were supposed to be fixed by 5ba2f67afb02c5302b2898949ed6fc3b3d37dcf1,
> where a call to NULL happens.
> 
> Not all tvaudio chips allow controlling bass/treble. So, the driver
> has a table with a flag to indicate if the chip does support it.
> 
> Unfortunately, the handling of this logic were broken for a very long
> time (probably since the first module version). Due to that, an OOPS
> were generated for devices that don't support bass/treble.

Just complementing, this was a regression, caused by dc3d75da05c3ff2dd6510c32a11deacced49d1a1.

-- 

Cheers,
Mauro
