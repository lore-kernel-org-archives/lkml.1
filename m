Return-Path: <linux-kernel-owner+w=401wt.eu-S1765987AbXLTOlh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765987AbXLTOlh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 09:41:37 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1765232AbXLTOi1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 09:38:27 -0500
Received: from hawking.rebel.net.au ([203.20.69.83]:38654 "EHLO
	hawking.rebel.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1765214AbXLTOiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 09:38:25 -0500
Message-ID: <476A7E7E.7030704@davidnewall.com>
Date: Fri, 21 Dec 2007 01:08:54 +1030
From: David Newall <david@davidnewall.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.2) Gecko/20070221 SeaMonkey/1.1.1
MIME-Version: 1.0
To: "Hemmann, Volker Armin" <volker.armin.hemmann@tu-clausthal.de>
CC: Scott <linux-kernel@bluecamel.eml.cc>, linux-kernel@vger.kernel.org
Subject: Re: almost daily Kernel oops with 2.6.23.9 - and now 2.6.23.11 as
 well
References: <200712160106.00464.volker.armin.hemmann@tu-clausthal.de> <200712200313.54425.volker.armin.hemmann@tu-clausthal.de> <1198122641.8341.1.camel@oasis.donpoo.home> <200712200653.28996.volker.armin.hemmann@tu-clausthal.de>
In-Reply-To: <200712200653.28996.volker.armin.hemmann@tu-clausthal.de>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>> On Montag, 17. Dezember 2007, you wrote:
>>>
>>> and another one, this time tainted with the nvidia module:
>>> 5194.130985] Unable to handle kernel paging request at 0000030000000000
>>> RIP:

Numbers like that don't suggest hardware faults.  All those zeros: It's 
far too round.  Sounds very like software.  In fact, it sounds like the 
start of significant hardware region.   And lo! there's a closed-source, 
possibly buggy nvidia module.  Try another; older or newer are equally good.
