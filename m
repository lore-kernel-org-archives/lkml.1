Return-Path: <linux-kernel-owner+w=401wt.eu-S1759799AbXFDRao@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759799AbXFDRao (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2007 13:30:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757514AbXFDRaW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Jun 2007 13:30:22 -0400
Received: from terminus.zytor.com ([192.83.249.54]:53772 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756975AbXFDRaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2007 13:30:20 -0400
Message-ID: <46644B99.1060304@zytor.com>
Date: Mon, 04 Jun 2007 10:27:53 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.0 (X11/20070419)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Jeff Garzik <jeff@garzik.org>, Randy Dunlap <rdunlap@xenotime.net>,
       Al Viro <viro@ftp.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
       akpm@linux-foundation.org
Subject: Re: [RFC] Documentation/CodingStyle: Add rules for goto labels
References: <20070603142450.GA4230@localhost.localdomain> <20070603142939.GW4095@ftp.linux.org.uk> <20070603074552.430c3d02.rdunlap@xenotime.net> <4662DFCF.3010606@garzik.org> <20070604045857.GE2161@localhost.localdomain> <4663B84E.2060103@goop.org>
In-Reply-To: <4663B84E.2060103@goop.org>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> WANG Cong wrote:
>> I just wonder, if a goto label is nested in a while/for/if/switch block, aligning it in
>> the first column maybe a bit ugly. (I know mostly it is not in any while/for/if/switch block.)
> 
> In general goto labels are not scoped, so there's no point in pretending
> they are.  It might make sense to indent a label deeper if you've
> actually declared it local (__label__).
> 

goto labels are scoped in one sense: they are only reachable from inside
the block they are defined in, so I would disagree with this statement.

	-hpa
