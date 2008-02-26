Return-Path: <linux-kernel-owner+w=401wt.eu-S932446AbYBZXgi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932446AbYBZXgi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Feb 2008 18:36:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754226AbYBZXgZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 26 Feb 2008 18:36:25 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:49761 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653AbYBZXgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Feb 2008 18:36:23 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Message-ID: <47C4A26D.1030109@s5r6.in-berlin.de>
Date: Wed, 27 Feb 2008 00:36:13 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.8.1.12) Gecko/20080219 SeaMonkey/1.1.8
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: -next build logs
References: <47C45749.3010001@s5r6.in-berlin.de> <20080227101338.5089d72d.sfr@canb.auug.org.au>
In-Reply-To: <20080227101338.5089d72d.sfr@canb.auug.org.au>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stephen Rothwell wrote:
> On Tue, 26 Feb 2008 19:15:37 +0100 Stefan Richter <stefanr@s5r6.in-berlin.de> wrote:
>> the allmodconfig builds at http://kisskb.ellerman.id.au/kisskb/branch/9/ 
>> seem to lack a few drivers even though they are properly enabled in the 
>> respective config.  Is it simply because everything is rebuilt on top of 
>> a previous build?
> 
> That's interesting.  I thought they were built from a clean tree each
> time but I will discuss this with Michael Ellerman who created this build
> system.

I noticed it while looking how well drivers/firewire/ (CONFIG_FIREWIRE*) 
and drivers/ieee1394/ (CONFIG_IEEE1394*) are compiled in -next; i.e. you 
can just check for the firewire ones as one example of potentially 
missing compiles.  On the other hand, I also saw some LDs without 
corresponding preceding CCs, so it rather looks like there was already 
something compiled.

>> Do you mail only errors to maintainers or also compiler warnings?
> 
> Currently I am only concerned with actual failures.

OK, I will just look myself into the logs then.  Thanks,
-- 
Stefan Richter
-=====-==--- --=- ==-==
http://arcgraph.de/sr/
