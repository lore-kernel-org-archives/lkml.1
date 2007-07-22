Return-Path: <linux-kernel-owner+w=401wt.eu-S1760760AbXGVREy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760760AbXGVREy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 13:04:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753957AbXGVREs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 13:04:48 -0400
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:4207 "EHLO
	pd4mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464AbXGVREr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 13:04:47 -0400
Date: Sun, 22 Jul 2007 11:05:19 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: processor family setting for Pentium D
In-reply-to: <fa.mkagl9LGp73SZOVteb979N2BWtI@ifi.uio.no>
To: Tilman Schmidt <tilman@imap.cc>
Cc: LKML <linux-kernel@vger.kernel.org>
Message-id: <46A38E4F.1080107@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-15; format=flowed
Content-transfer-encoding: 7bit
References: <fa.mkagl9LGp73SZOVteb979N2BWtI@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Tilman Schmidt wrote:
> Probably a stupid question, but I spent some time searching the net
> for an answer without success:
> 
> What is the correct setting of the "Processor family" configuration
> option for a 32 bit kernel which is going to run on an Intel
> Pentium D 940 processor (cpu family 15, model 6)? It doesn't seem
> to fit any of the available selections.
> 
> More generally, what is the correct way of selecting the processor
> family option for a CPU whose name doesn't appear anywhere in the
> prompts or help texts in arch/i386/Kconfig.cpu? I guess there must
> be a way of deducing it from the content of /proc/cpuinfo, only I
> cannot figure out how.
> 
> Thanks,
> Tilman

Pentium D is based on the Pentium 4 (basically two P4 chips in one 
package), therefore that option would be the one you would want.

If it's not listed in the menu, then you pretty much have to go on what 
else is in there that's similar. Likely Pentium D should be added to the 
menu listing for Pentium 4 though.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

