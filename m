Return-Path: <linux-kernel-owner+w=401wt.eu-S1761393AbXGDOcp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761393AbXGDOcp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 10:32:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759529AbXGDOch
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 10:32:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:49485 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759411AbXGDOch (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 10:32:37 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Theodore Tso <tytso@mit.edu>
Subject: Re: [linux-pm] [PATCH] Remove process freezer from suspend to RAM pathway
Date: Wed, 4 Jul 2007 16:40:12 +0200
User-Agent: KMail/1.9.5
Cc: Paul Mackerras <paulus@samba.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org
References: <20070703211227.GA28758@srcf.ucam.org> <200707041325.55779.rjw@sisk.pl> <20070704124133.GA5836@thunk.org>
In-Reply-To: <20070704124133.GA5836@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707041640.12832.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, 4 July 2007 14:41, Theodore Tso wrote:
> On Wed, Jul 04, 2007 at 01:25:55PM +0200, Rafael J. Wysocki wrote:
> > > Don't know what exactly?
> > 
> > How many drivers will be adversely affected by the $subject change.
> 
> Ok, so how about a CONFIG option which removes the freezer, so we can
> find out experimentally how many people without it?  We can make it be
> experimental at first, or (my preference) make it be the default
> initially, and if people complain that their laptop's suspend feature
> is broken, we can tell them how to turn back on the
> CONFIG_FREEZER_DEPRECATED option.

The freezer is generally still necessary for hibernation, so I won't call
it "DEPRECATED'.

Moreover, I'd prefer to make drivers use different callbacks for hibernation
and suspend before we do that.

Greetings,
Rafael


-- 
"Premature optimization is the root of all evil." - Donald Knuth
