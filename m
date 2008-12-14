Return-Path: <linux-kernel-owner+w=401wt.eu-S1753343AbYLNCCk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753343AbYLNCCk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Dec 2008 21:02:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751871AbYLNCCa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 13 Dec 2008 21:02:30 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51892 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751141AbYLNCCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Dec 2008 21:02:30 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <49446923.5040606@s5r6.in-berlin.de>
Date: Sun, 14 Dec 2008 03:02:11 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.18) Gecko/20081116 SeaMonkey/1.1.13
MIME-Version: 1.0
To: Bill Fink <billfink@mindspring.com>
CC: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org,
       Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH 2/2] ieee1934: dv1394 interrupt enabling/disabling broken
 on big-endian
References: <1229210489.11257.16.camel@brick>	<4944561D.4010608@s5r6.in-berlin.de> <20081213204137.d150645c.billfink@mindspring.com>
In-Reply-To: <20081213204137.d150645c.billfink@mindspring.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Bill Fink wrote:
> On Sun, 14 Dec 2008, Stefan Richter wrote:
>> Looks like a bug + correct fix indeed.  Apparently dv1394 was never used on big
>> endian PCs.
...
> I use dv1394 on a big-endian PPC system (2.6.15 kernel) to watch DV video
> via xine, and this has always worked fine for me.

Could you try to apply the patch to your kernel to test it?  You can get
it in plaintext e.g. from
http://user.in-berlin.de/~s5r6/linux1394/submitted/843-ieee1934-dv1394-interrupt-enabling_disabling-broken-on-big-endian.patch

> And this shouldn't be phased out until the equivalent functionality is
> added to ffmpeg via the new APIs.

Or perhaps by a dv1394 replacement module which plugs to the V4L2 API.
-- 
Stefan Richter
-=====-==--- ==-- -===-
http://arcgraph.de/sr/
