Return-Path: <linux-kernel-owner+w=401wt.eu-S1761542AbXHCH4i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761542AbXHCH4i (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 03:56:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757243AbXHCH4b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 03:56:31 -0400
Received: from sovereign.computergmbh.de ([85.214.69.204]:38738 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757134AbXHCH4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 03:56:31 -0400
Date: Fri, 3 Aug 2007 09:56:30 +0200 (CEST)
From: Jan Engelhardt <jengelh@computergmbh.de>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
cc: Al Viro <viro@ftp.linux.org.uk>,
       Stefan Richter <stefanr@s5r6.in-berlin.de>,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
In-Reply-To: <Pine.LNX.4.60.0708030128340.6774@poirot.grange>
Message-ID: <Pine.LNX.4.64.0708030955330.495@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange>
 <p73vebxmysb.fsf@bingen.suse.de> <Pine.LNX.4.60.0708022231160.6774@poirot.grange>
 <46B25B5E.30406@s5r6.in-berlin.de> <Pine.LNX.4.60.0708030046230.6774@poirot.grange>
 <20070802230914.GT21089@ftp.linux.org.uk> <Pine.LNX.4.60.0708030128340.6774@poirot.grange>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


On Aug 3 2007 01:30, Guennadi Liakhovetski wrote:
>On Fri, 3 Aug 2007, Al Viro wrote:
>
>> It doesn't change the fact that use of c[4] or strlen(c) or strcpy(..., c)
>> means nasal demon country for you.
>
>Haha, funny. You, certainly, may think whatever you want, I'm anyway 
>greatful to you and to all the rest for the trouble you took to find THE 
>quote that actually answers the question.

So back to the topic - if you want to check whether the kernel
'accidentally' uses

	char foo[4] = "abcd";

change gcc or sparse to warn about this and then sort out the pieces
which are good. :)


	Jan
-- 
