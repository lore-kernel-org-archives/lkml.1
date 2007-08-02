Return-Path: <linux-kernel-owner+w=401wt.eu-S1760271AbXHBX0q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760271AbXHBX0q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 19:26:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751893AbXHBX0i
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 19:26:38 -0400
Received: from mail.gmx.net ([213.165.64.20]:40001 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751158AbXHBX0h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 19:26:37 -0400
X-Authenticated: #20450766
X-Provags-ID: V01U2FsdGVkX1+moFsfRmKmBP35V+1mOsbKl6vNdThAMSHXYohIrx
	z4ppmEYmKf8BP5
Date: Fri, 3 Aug 2007 01:26:40 +0200 (CEST)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
To: Randy Dunlap <rdunlap@xenotime.net>
cc: Robert Hancock <hancockr@shaw.ca>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
In-Reply-To: <20070802155434.b085219c.rdunlap@xenotime.net>
Message-ID: <Pine.LNX.4.60.0708030056390.6774@poirot.grange>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
 <p73vebxmysb.fsf@bingen.suse.de> <Pine.LNX.4.60.0708022231160.6774@poirot.grange>
 <46B2578A.805@s5r6.in-berlin.de> <Pine.LNX.4.60.0708030024490.6774@poirot.grange>
 <20070802155434.b085219c.rdunlap@xenotime.net>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2 Aug 2007, Randy Dunlap wrote:

> C99 spec that Al referred you to (available for around US$18 as a pdf)
> says in 6.7.8, para. 14 (where Al said):
> 
> "An array of character type may be initialized by a character string literal, optionally
> enclosed in braces. Successive characters of the character string literal (including the
> terminating null character if there is room or if the array is of unknown size) initialize the
> elements of the array."

Wow... So, the terminating '\0' in the string constant IS "special" and 
"optional"... Ok, then, THIS does answer my question, THIS I can 
understand, and, ghm, accept...

Thanks to all who tried to explain this to me and sorry it took so long...

Thanks
Guennadi
---
Guennadi Liakhovetski
