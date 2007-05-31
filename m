Return-Path: <linux-kernel-owner+w=401wt.eu-S1761974AbXEaUAr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761974AbXEaUAr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2007 16:00:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760072AbXEaUAk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 May 2007 16:00:40 -0400
Received: from mx1.redhat.com ([66.187.233.31]:41468 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759192AbXEaUAj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2007 16:00:39 -0400
Date: Thu, 31 May 2007 15:59:17 -0400
From: Dave Jones <davej@redhat.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andy Whitcroft <apw@shadowen.org>, Andrew Morton <akpm@osdl.org>,
       Randy Dunlap <rdunlap@xenotime.net>,
       Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] add a trivial patch style checker II
Message-ID: <20070531195917.GC31153@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andi Kleen <andi@firstfloor.org>, Andy Whitcroft <apw@shadowen.org>,
	Andrew Morton <akpm@osdl.org>, Randy Dunlap <rdunlap@xenotime.net>,
	Joel Schopp <jschopp@austin.ibm.com>, linux-kernel@vger.kernel.org
References: <9a1288909c10f2935af82ec5cea0c46b@pinky> <p738xb8fjv2.fsf@bingen.suse.de> <465BECCC.5030001@shadowen.org> <20070531120753.GA2538@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070531120753.GA2538@one.firstfloor.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2007 at 02:07:53PM +0200, Andi Kleen wrote:
 > > Yeah, that is a very sensible idea.
 > > 
 > > > Possible further checks that might make sense:
 > > > - panic() anywhere in drivers/* 
 > > > - externs in .c files without asmlinkage
 > > > - general checking that everything in a fully visible {} block is the right 
 > > > indentation
 > > > 
 > 
 > Here are some more warnings I would like to see:
 > 
 > - Warning for any spinlock/mutex definition that doesn't have a comment
 > nearby (all locks ought to be documented) 

Also barriers. (Probably even moreso).

	Dave

-- 
http://www.codemonkey.org.uk
