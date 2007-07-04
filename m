Return-Path: <linux-kernel-owner+w=401wt.eu-S1760829AbXGDMmQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760829AbXGDMmQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 08:42:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756518AbXGDMmA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 08:42:00 -0400
Received: from thunk.org ([69.25.196.29]:48880 "EHLO thunker.thunk.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753617AbXGDMmA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 08:42:00 -0400
Date: Wed, 4 Jul 2007 08:41:33 -0400
From: Theodore Tso <tytso@mit.edu>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Paul Mackerras <paulus@samba.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
Message-ID: <20070704124133.GA5836@thunk.org>
Mail-Followup-To: Theodore Tso <tytso@mit.edu>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Paul Mackerras <paulus@samba.org>,
	Matthew Garrett <mjg59@srcf.ucam.org>,
	linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070703211227.GA28758@srcf.ucam.org> <200707041242.59552.rjw@sisk.pl> <18059.32111.58643.97174@cargo.ozlabs.ibm.com> <200707041325.55779.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <200707041325.55779.rjw@sisk.pl>
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on thunker.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 04, 2007 at 01:25:55PM +0200, Rafael J. Wysocki wrote:
> > Don't know what exactly?
> 
> How many drivers will be adversely affected by the $subject change.

Ok, so how about a CONFIG option which removes the freezer, so we can
find out experimentally how many people without it?  We can make it be
experimental at first, or (my preference) make it be the default
initially, and if people complain that their laptop's suspend feature
is broken, we can tell them how to turn back on the
CONFIG_FREEZER_DEPRECATED option.

							- Ted
