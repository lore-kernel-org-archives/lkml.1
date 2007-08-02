Return-Path: <linux-kernel-owner+w=401wt.eu-S1759848AbXHBXDq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759848AbXHBXDq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 19:03:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756210AbXHBXDi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 19:03:38 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:47541 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755293AbXHBXDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 19:03:37 -0400
Date: Fri, 3 Aug 2007 00:03:34 +0100
From: Al Viro <viro@ftp.linux.org.uk>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       Robert Hancock <hancockr@shaw.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
Message-ID: <20070802230333.GS21089@ftp.linux.org.uk>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange> <p73vebxmysb.fsf@bingen.suse.de> <Pine.LNX.4.60.0708022231160.6774@poirot.grange> <46B2578A.805@s5r6.in-berlin.de> <Pine.LNX.4.60.0708030024490.6774@poirot.grange> <20070802155434.b085219c.rdunlap@xenotime.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070802155434.b085219c.rdunlap@xenotime.net>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 02, 2007 at 03:54:34PM -0700, Randy Dunlap wrote:
> > 
> > And, Stefan, there is a perfect way to specify a "0123" without the '\0' - 
> > {'0', '1', '2', '3'}.
> 
> We are actually a bit beyond traditional K&R, fwiw.

Not in that area - this behaviour is precisely what traditional K&R
had all along.  Unchanged.
