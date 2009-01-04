Return-Path: <linux-kernel-owner+w=401wt.eu-S1758959AbZADVEI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758959AbZADVEI (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Jan 2009 16:04:08 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754291AbZADVDz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Jan 2009 16:03:55 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:47440 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbZADVDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Jan 2009 16:03:54 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <4961241C.5020503@s5r6.in-berlin.de>
Date: Sun, 04 Jan 2009 22:03:24 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Bill Fink <billfink@mindspring.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 2/2] ieee1934: dv1394 interrupt enabling/disabling broken
 on big-endian
References: <1229210489.11257.16.camel@brick>	<4944561D.4010608@s5r6.in-berlin.de>	<20081213204137.d150645c.billfink@mindspring.com>	<49446923.5040606@s5r6.in-berlin.de>	<20081223172300.5bd19846.billfink@mindspring.com>	<20081225220244.1eacb39d.billfink@mindspring.com>	<495F976C.8030105@s5r6.in-berlin.de> <20090103211843.d36d252f.billfink@mindspring.com>
In-Reply-To: <20090103211843.d36d252f.billfink@mindspring.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Fink wrote:
> Although I admit to being mystified how it works both
> before and after the patch, since the cpu_to_le32() calls that were
> added should result in byte swapping on PPC that wasn't being done
> before.  I guess that either the code paths involved aren't actually
> being triggered by my xine DV viewing, or there's some fortuitous
> palindromic setting of bits.

I agree.  If I had more spare time for these things I would try to find
out what's really going on.  But since the patch really looks like the
right thing to do and doesn't regress, I will send it in without further
investigation.
-- 
Stefan Richter
-=====-==--= ---= --=--
http://arcgraph.de/sr/
