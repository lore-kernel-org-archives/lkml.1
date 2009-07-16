Return-Path: <linux-kernel-owner+w=401wt.eu-S1754485AbZGPLqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754485AbZGPLqk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 07:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752085AbZGPLqj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 07:46:39 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:39866 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751913AbZGPLqi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 07:46:38 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4A5F12FB.2050302@s5r6.in-berlin.de>
Date: Thu, 16 Jul 2009 13:46:03 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.8.1.22) Gecko/20090630 SeaMonkey/1.1.17
MIME-Version: 1.0
To: subrata@linux.vnet.ibm.com
CC: Artem Bityutskiy <dedekind@infradead.org>, linux-mtd@lists.infradead.org,
       Adrian Hunter <adrian.hunter@nokia.com>,
       Sachin P Sant <sachinp@linux.vnet.ibm.com>,
       David Howells <dhowells@redhat.com>,
       Balbir Singh <balbir@linux.vnet.ibm.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 02/06] Fix compilation warning for fs/ubifs/commit.c
References: <20090715021901.4112.45973.sendpatchset@subratamodak.linux.ibm.com>	 <1247640750.11353.6.camel@localhost.localdomain>	 <4A5E1D1A.3090705@s5r6.in-berlin.de>	 <1247738232.11353.90.camel@localhost.localdomain> <1247742274.5572.8.camel@subratamodak.linux.ibm.com>
In-Reply-To: <1247742274.5572.8.camel@subratamodak.linux.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subrata Modak wrote:
>> Well, I just thought this type of warnings and way of fixing is very
>> standard because I saw many similar fixes all over the place.
> 
> Correct. There has been other warning fixes i have sent to LKML, where i
> have tweaked the code to fix the compilation, but, code tweaking may not
> be possible in this case.

Wrong goal.  The goal of a patch should be to improve the code.

To remove false-positive warnings from compilation can only be a 
secondary goal.

(See my other post.)

BTW, which compiler do you use?  I quickly enabled ubifs here, first 
without and then with its various sub-uptions, but didn't get a warning 
here with "gcc (Gentoo 4.3.2-r3 p1.6, pie-10.1.5) 4.3.2".
-- 
Stefan Richter
-=====-==--= -=== =----
http://arcgraph.de/sr/
