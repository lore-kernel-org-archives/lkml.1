Return-Path: <linux-kernel-owner+w=401wt.eu-S1759153AbXFQBrn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759153AbXFQBrn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2007 21:47:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754311AbXFQBrg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 16 Jun 2007 21:47:36 -0400
Received: from twinlark.arctic.org ([207.29.250.54]:33399 "EHLO
	twinlark.arctic.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753388AbXFQBrg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2007 21:47:36 -0400
Date: Sat, 16 Jun 2007 18:47:35 -0700 (PDT)
From: dean gaudet <dean@arctic.org>
To: Wakko Warner <wakko@animx.eu.org>
cc: Neil Brown <neilb@suse.de>, david@lang.hm, linux-kernel@vger.kernel.org,
       linux-raid@vger.kernel.org
Subject: Re: limits on raid
In-Reply-To: <20070616140857.GA4206@animx.eu.org>
Message-ID: <Pine.LNX.4.64.0706161845180.24938@twinlark.arctic.org>
References: <Pine.LNX.4.64.0706141957020.29630@asgard.lang.hm>
 <18034.479.256870.600360@notabene.brown> <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm>
 <18034.3676.477575.490448@notabene.brown> <20070616020320.GB2002@animx.eu.org>
 <18035.23867.576212.859440@notabene.brown> <20070616140857.GA4206@animx.eu.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Jun 2007, Wakko Warner wrote:

> When I've had an unclean shutdown on one of my systems (10x 50gb raid5) it's
> always slowed the system down when booting up.  Quite significantly I must
> say.  I wait until I can login and change the rebuild max speed to slow it
> down while I'm using it.   But that is another thing.

i use an external write-intent bitmap on a raid1 to avoid this... you 
could use internal bitmap but that slows down i/o too much for my tastes.  
i also use an external xfs journal for the same reason.  2 disk raid1 for 
root/journal/bitmap, N disk raid5 for bulk storage.  no spindles in 
common.

-dean
