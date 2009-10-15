Return-Path: <linux-kernel-owner+w=401wt.eu-S1762370AbZJOBYE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762370AbZJOBYE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Oct 2009 21:24:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760702AbZJOBYE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Oct 2009 21:24:04 -0400
Received: from thunk.org ([69.25.196.29]:54068 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755614AbZJOBYD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Oct 2009 21:24:03 -0400
Date: Wed, 14 Oct 2009 21:23:21 -0400
From: Theodore Tso <tytso@mit.edu>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: "Carlos R. Mafra" <crmafra2@gmail.com>, Eric Anholt <eric@anholt.net>,
       linux-kernel@vger.kernel.org, Keith Packard <keithp@keithp.com>
Subject: Re: 2.6.32 regression (bisected): Video tearing/glitching with
	T400 laptops
Message-ID: <20091015012321.GA7472@mit.edu>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	Jesse Barnes <jbarnes@virtuousgeek.org>,
	"Carlos R. Mafra" <crmafra2@gmail.com>,
	Eric Anholt <eric@anholt.net>, linux-kernel@vger.kernel.org,
	Keith Packard <keithp@keithp.com>
References: <E1Mtqnb-0002x7-TJ@closure.thunk.org> <20091008103620.5e5aae66@jbarnes-g45> <20091010204106.GA8251@mit.edu> <20091012095438.1e82b54f@jbarnes-g45> <20091012184651.GA4603@Pilar.aei.mpg.de> <20091012120510.16bd1194@jbarnes-g45> <20091013023146.GA8414@mit.edu> <20091013100135.2b3d914f@jbarnes-g45>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091013100135.2b3d914f@jbarnes-g45>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@mit.edu
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 13, 2009 at 10:01:35AM -0700, Jesse Barnes wrote:
> 
> Arg, I'm running out of ideas...  How about this hack?  I'll chat with
> the chipset guys to see if we can figure out what's going on here...
> 

So the first patch plus this second patch actually made things *worse*
on the T400.  I'll try adding the 3rd patch now.

						- Ted
