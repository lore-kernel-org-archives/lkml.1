Return-Path: <linux-kernel-owner+w=401wt.eu-S1754106AbYIDQLZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106AbYIDQLZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2008 12:11:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751961AbYIDQLR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 4 Sep 2008 12:11:17 -0400
Received: from e2.ny.us.ibm.com ([32.97.182.142]:40050 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752233AbYIDQLR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2008 12:11:17 -0400
Subject: Re: [RFC v3][PATCH 2/9] General infrastructure for checkpoint
	restart
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Serge E. Hallyn" <serue@us.ibm.com>
Cc: Oren Laadan <orenl@cs.columbia.edu>, linux-kernel@vger.kernel.org,
       containers@lists.linux-foundation.org, jeremy@goop.org, arnd@arndb.de
In-Reply-To: <20080904160311.GC19364@us.ibm.com>
References: <Pine.LNX.4.64.0809040354440.460@takamine.ncl.cs.columbia.edu>
	 <Pine.LNX.4.64.0809040402170.5982@takamine.ncl.cs.columbia.edu>
	 <20080904160311.GC19364@us.ibm.com>
Content-Type: text/plain
Date: Thu, 04 Sep 2008 09:09:52 -0700
Message-Id: <1220544592.23386.2.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-09-04 at 11:03 -0500, Serge E. Hallyn wrote:
> Dave, are you happy with the allocations here, or were you objecting
> to cr_hbuf_get() and cr_hbuf_put()?

I still don't think there's really enough justification as it stands,
but don't let me get in the way.  If it ends up being an issue, it's
pretty straightforward to rip them out or put back.  The code is very
nice that way.

-- Dave

