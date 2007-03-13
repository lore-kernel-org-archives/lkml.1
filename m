Return-Path: <linux-kernel-owner+w=401wt.eu-S932081AbXCMSoM@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932081AbXCMSoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2007 14:44:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932149AbXCMSoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Mar 2007 14:44:12 -0400
Received: from services106.cs.uwaterloo.ca ([129.97.152.164]:45462 "EHLO
	services106.cs.uwaterloo.ca" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932081AbXCMSoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2007 14:44:11 -0400
Date: Tue, 13 Mar 2007 14:43:47 -0400 (EDT)
From: Ashif Harji <asharji@cs.uwaterloo.ca>
To: Jan Kara <jack@suse.cz>
cc: Nick Piggin <npiggin@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: do_generic_mapping_read performance issue
In-Reply-To: <20070312173500.GF23532@duck.suse.cz>
Message-ID: <Pine.GSO.4.64.0703131438580.8193@cpu102.cs.uwaterloo.ca>
References: <Pine.GSO.4.64.0703081612290.1080@cpu102.cs.uwaterloo.ca>
 <20070312142012.GH30777@atrey.karlin.mff.cuni.cz> <20070312143900.GB6016@wotan.suse.de>
 <20070312151355.GB23532@duck.suse.cz> <Pine.GSO.4.64.0703121247210.7679@cpu102.cs.uwaterloo.ca>
 <20070312173500.GF23532@duck.suse.cz>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-2.0 (services106.cs.uwaterloo.ca [129.97.152.132]); Tue, 13 Mar 2007 14:44:02 -0400 (EDT)
X-Miltered: at psamathe with ID 45F6F0ED.001 by Joe's j-chkmail (http://j-chkmail.ensmp.fr)!
X-UUID: 5c0f3a03-0d40-47d2-9696-8cd68e94388b
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


>> I would like to submit a patch to fix the performance problem.  The
>> simplest solution is to remove the check.  Even in the situation where an
>> application does not read in PAGE_SIZE multiples as described above, if
>> the page is accessed frequently it should remain in the cache.  However, I
>> am open to suggestions for a more sophisticated scheme.
>
>  Well, yes, that's an obvious solution. I just wanted to make sure that
> such change won't break some other load. But so far it seems it won't...

I would like to find out if the change I am suggesting will cause any 
other problems.  Is there someone else I should contact before submitting 
a patch?  Or should I just wait another day or two for comments?

ashif.
