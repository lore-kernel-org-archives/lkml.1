Return-Path: <linux-kernel-owner+w=401wt.eu-S1757514AbZE3XEX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514AbZE3XEX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 May 2009 19:04:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756138AbZE3XEO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 May 2009 19:04:14 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:23907 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbZE3XEM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 May 2009 19:04:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=bhZQRD+pFkw6eLkjcrj9gaRdeuy/MkR4pO0mtoM2PpkURk+v8kDE25q6nEOokXVDQm
         kf3hL46e7ihxVM62YppPv1iwx/yrLc4/sOWaXCgf670V0mXjxclt4DovNeE51Pcvo2ng
         fglNuBVAzKXcO5zuMELoOBTwKV/IsNAfUuILw=
Date: Sun, 31 May 2009 01:04:10 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Harald Dunkel <harald.dunkel@t-online.de>,
       Jeff Mahoney <jeffm@suse.com>
Subject: Re: [Bug #13374] reiserfs blocked for more than 120secs
Message-ID: <20090530230408.GC8739@nowhere>
References: <4to6E2myxvG.A.muC.aIbIKB@chimera> <LEcEO2518_I.A.MgD.wIbIKB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <LEcEO2518_I.A.MgD.wIbIKB@chimera>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 30, 2009 at 09:37:36PM +0200, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.29.  Please verify if it still should be listed and let me know
> (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=13374
> Subject		: reiserfs blocked for more than 120secs
> Submitter	: Harald Dunkel <harald.dunkel@t-online.de>
> Date		: 2009-05-23 8:52 (8 days old)
> References	: http://marc.info/?l=linux-kernel&m=124306880410811&w=4
> 
> 


Trenton D. Adams has reported something very similar for -rc3:

http://lkml.org/lkml/2009/5/29/389

Someone holds the j_commit_mutex but never release it...

(Adding Jeff Mahoney in cc )

