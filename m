Return-Path: <linux-kernel-owner+w=401wt.eu-S1760160AbYJIRqU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760160AbYJIRqU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2008 13:46:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755894AbYJIRqM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 9 Oct 2008 13:46:12 -0400
Received: from sous-sol.org ([216.99.217.87]:43466 "EHLO sequoia.sous-sol.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753807AbYJIRqL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2008 13:46:11 -0400
Date: Thu, 9 Oct 2008 10:44:27 -0700
From: Chris Wright <chrisw@sous-sol.org>
To: Pavel Machek <pavel@suse.cz>
Cc: "Cihula, Joseph" <joseph.cihula@intel.com>, linux-kernel@vger.kernel.org,
       "Wang, Shane" <shane.wang@intel.com>, "Wei, Gang" <gang.wei@intel.com>,
       "Van De Ven, Arjan" <arjan.van.de.ven@intel.com>,
       "Mallick, Asit K" <asit.k.mallick@intel.com>,
       "Nakajima, Jun" <jun.nakajima@intel.com>,
       Chris Wright <chrisw@redhat.com>, Jan Beulich <jbeulich@novell.com>,
       mingo@elte.hu, tytso@mit.edu
Subject: Re: [RFC][PATCH 0a/3] TXT: Intel(R) Trusted Execution Technology
	support for Linux - Overview
Message-ID: <20081009174427.GB6912@sequoia.sous-sol.org>
References: <D936D925018D154694D8A362EEB0892005AC105B@orsmsx416.amr.corp.intel.com> <20081009125311.GD1623@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081009125311.GD1623@ucw.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Pavel Machek (pavel@suse.cz) wrote:
> Ok, I don't get it, why would I want to measure my kernel?

Trusted boot.  There's always the double-edge sword w/ this.  Clearly,
a requirement is that you don't just brick your own box, and have some
policy/mechanism for defining how you'd use trusted boot.  I believe
that's all there w/ TXT patch (since it's mostly handled before kernel
boots, TXT kernel bit is just to help w/ handoff).

> I see why Disney would want to do that, but I don't see why we would
> want to help them.
> 
> Plus, the fact that trusted mode is pretty much incompatible with
> s3/s4 makes it useless, right?

Why do you say that?  Did you look at patch 3/3, see tboot_sleep().

thanks,
-chris
