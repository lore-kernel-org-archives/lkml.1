Return-Path: <linux-kernel-owner+w=401wt.eu-S1753137AbYCMIGy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753137AbYCMIGy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2008 04:06:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751293AbYCMIGm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 13 Mar 2008 04:06:42 -0400
Received: from phunq.net ([64.81.85.152]:48766 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751246AbYCMIGk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2008 04:06:40 -0400
From: Daniel Phillips <phillips@phunq.net>
To: david@lang.hm
Subject: Re: [ANNOUNCE] Ramback: faster than a speeding bullet
Date: Thu, 13 Mar 2008 00:06:26 -0800
User-Agent: KMail/1.9.5
Cc: David Newall <davidn@davidnewall.com>, Chris Friesen <cfriesen@nortel.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, linux-kernel@vger.kernel.org
References: <200803092346.17556.phillips@phunq.net> <200803130012.36763.phillips@phunq.net> <alpine.DEB.1.00.0803130046190.3786@asgard.lang.hm>
In-Reply-To: <alpine.DEB.1.00.0803130046190.3786@asgard.lang.hm>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803130106.26910.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 13 March 2008 00:55, david@lang.hm wrote:
> if you are not measuring the time to get from ram to disk (which you are 
> not doing in your ramback device) syncs are meaningless.

There was a time when punchcards ruled and everybody was nervous about
storing their data on magnetic media.  I remember it well, you may not.
But you are repeating that bit of history, there is a proverb in there
somewhere.

> > Why am I reminded of old arguments like "if men were meant to fly, God
> > would have given them wings"?  Please just give me your microsecond
> > scale transaction processing solution and I will be impressed and
> > grateful.  Until then... here is mine.  Service with a smile.
> 
> if you don't have to worry about unclean shutdowns then your system is not 
> needed. all you need to do is to create a ramdisk that you populate with 
> dd at boot time and save to disk with dd at shutdown. problem solved in a 
> couple lines of shell scripts and no kernel changes needed.
> 
> if you want the data to be safe in the face of unclean shutdowns and 
> crashes, then you need to figure out how to make the image on disk 
> consistant, and at this point you have basicly said that you don't think 
> that it's a problem. so we're back to what you can do today with a couple 
> lines of scripting.

Feel free.  You use your script, and somebody with a reliable UPS or
two can use my driver, once it is stabilized of course.  Just don't be
in business against them if being a few milliseconds slower on the
uptake means money lost.

Daniel
