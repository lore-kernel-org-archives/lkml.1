Return-Path: <linux-kernel-owner+w=401wt.eu-S1756838AbXHBWcT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838AbXHBWcT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2007 18:32:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755148AbXHBWcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Aug 2007 18:32:08 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:47623 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755007AbXHBWcH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2007 18:32:07 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <46B25B5E.30406@s5r6.in-berlin.de>
Date: Fri, 03 Aug 2007 00:31:58 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.4) Gecko/20070609 SeaMonkey/1.1.2
MIME-Version: 1.0
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
CC: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange> <p73vebxmysb.fsf@bingen.suse.de> <Pine.LNX.4.60.0708022231160.6774@poirot.grange>
In-Reply-To: <Pine.LNX.4.60.0708022231160.6774@poirot.grange>
X-Enigmail-Version: 0.94.1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Guennadi Liakhovetski wrote:
> with
> 
> 	char c[4] = "012345";
> 
> the compiler warns, but actually allocates a 6-byte long array...

Off-topic here, but:  sizeof c / sizeof *c == 4.
-- 
Stefan Richter
-=====-=-=== =--- ---==
http://arcgraph.de/sr/
