Return-Path: <linux-kernel-owner+w=401wt.eu-S1760386AbXHBWnQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760386AbXHBWnQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 18:43:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755617AbXHBWms
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 18:42:48 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47854 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754983AbXHBWmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 18:42:46 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46B25DD9.9040701@s5r6.in-berlin.de>
Date: Fri, 03 Aug 2007 00:42:33 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Robert Hancock <hancockr@shaw.ca>, Andi Kleen <andi@firstfloor.org>,
       linux-kernel@vger.kernel.org
Subject: (off-topic) Re: gcc fixed size char array initialization bug - known?
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange> <p73vebxmysb.fsf@bingen.suse.de> <Pine.LNX.4.60.0708022231160.6774@poirot.grange> <46B2578A.805@s5r6.in-berlin.de> <Pine.LNX.4.60.0708030024490.6774@poirot.grange>
In-Reply-To: <Pine.LNX.4.60.0708030024490.6774@poirot.grange>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> Robert, Stefan, I am sorry, I think, you are VERY wrong here.

You meant to say "C99 is very wrong".

> And, Stefan, there is a perfect way to specify a "0123" without the '\0' - 
> {'0', '1', '2', '3'}.

C99 says char c[4] = "0123"; is a perfect way to say char c[4] = {'0',
'1', '2', '3'};.  Do you want gcc to choose otherwise and ban the former
of the two idioms?
-- 
Stefan Richter
-=====-=-=== =--- ---==
http://arcgraph.de/sr/
