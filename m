Return-Path: <linux-kernel-owner+w=401wt.eu-S1759625AbXFDVgR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625AbXFDVgR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 17:36:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752446AbXFDVgG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 17:36:06 -0400
Received: from terminus.zytor.com ([192.83.249.54]:41686 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750793AbXFDVgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 17:36:05 -0400
Message-ID: <46648561.4000106@zytor.com>
Date: Mon, 04 Jun 2007 14:34:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Al Viro <viro@ftp.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels
References: <20070603142450.GA4230@localhost.localdomain> <20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net> <4662DFCF.3010606@garzik.org> <20070604045857.GE2161@localhost.localdomain> <4663B84E.2060103@goop.org> <46644B99.1060304@zytor.com> <46646164.3010406@goop.org>
In-Reply-To: <46646164.3010406@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> H. Peter Anvin wrote:
>> goto labels are scoped in one sense: they are only reachable from inside
>> the block they are defined in, so I would disagree with this statement.
>>   
> 
> Erm, no I think you're wrong there 

Yeah, I realized I was talking out of my ass there when Viro pointed
this out.  I has inadvertently generalized the rule "no skipping
automatics" to "no jump into blocks."

	-hpa
