Return-Path: <linux-kernel-owner+w=401wt.eu-S1763612AbXHCPQV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763612AbXHCPQV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2007 11:16:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762733AbXHCPQO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 3 Aug 2007 11:16:14 -0400
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:51470 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761604AbXHCPQN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2007 11:16:13 -0400
Message-ID: <46B346BC.3060404@s5r6.in-berlin.de>
Date: Fri, 03 Aug 2007 17:16:12 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.0; en-US; rv:1.8.1.5) Gecko/20070716 SeaMonkey/1.1.3
MIME-Version: 1.0
To: Jakub Jelinek <jakub@redhat.com>
CC: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
       linux-kernel@vger.kernel.org
Subject: Re: gcc fixed size char array initialization bug - known?
References: <Pine.LNX.4.60.0708022141420.6774@poirot.grange> <20070802234229.GU2063@devserv.devel.redhat.com>
In-Reply-To: <20070802234229.GU2063@devserv.devel.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jakub Jelinek wrote:
> ISO C99 is very obvious in that the terminating '\0' (resp. L'\0') from
> the string literal is only added if there is room in the array or if the
> array has unknown size.

I would say C99 is /explicit/ in this regard.
It doesn't seem like an overly /obvious/ language feature to me.
-- 
Stefan Richter
-=====-=-=== =--- ---==
http://arcgraph.de/sr/
