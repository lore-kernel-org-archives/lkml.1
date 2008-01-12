Return-Path: <linux-kernel-owner+w=401wt.eu-S1761515AbYALDP0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761515AbYALDP0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2008 22:15:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756485AbYALDPN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 Jan 2008 22:15:13 -0500
Received: from mx1.suse.de ([195.135.220.2]:47279 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756101AbYALDPM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2008 22:15:12 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 0/4] PM: Do not destroy/create devices while suspended (rev. 2)
Date: Sat, 12 Jan 2008 04:15:06 +0100
User-Agent: KMail/1.9.6
Cc: Greg KH <gregkh@suse.de>, Andrew Morton <akpm@linux-foundation.org>,
       rjw@sisk.pl, linux-pm@lists.linux-foundation.org,
       linux-acpi@vger.kernel.org, lenb@kernel.org,
       linux-kernel@vger.kernel.org, pavel@suse.cz, mingo@elte.hu,
       tglx@linutronix.de
References: <Pine.LNX.4.44L0.0801112208030.21411-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.0801112208030.21411-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Disposition: inline
Message-Id: <200801120415.07176.ak@suse.de>
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> The real problem is that our current email workflow patterns don't 
> provide a standardized way for maintainers to tell when a new patch 
> submission is meant to override or replace an earlier submission (or 
> even a set of earlier submissions).  Does anybody have some suggestions 
> for a good way to do this?

The versioning approach pioneered by Christoph Lameter seems to work
reasonably well.

If you post a new version increase a version number and add it with "vXXX" to the
Subject.

Also add a short change log between versions at the bottom; e.g. v1->v2: .... etc.

Then it is always clear what is the latest'n'greatest.

-Andi
