Return-Path: <linux-kernel-owner+w=401wt.eu-S1752541AbXCDXtc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752541AbXCDXtc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2007 18:49:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752177AbXCDXtc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 4 Mar 2007 18:49:32 -0500
Received: from shawidc-mo1.cg.shawcable.net ([24.71.223.10]:15963 "EHLO
	pd2mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752541AbXCDXtb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2007 18:49:31 -0500
Date: Sun, 04 Mar 2007 17:49:30 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: CK804 SATA Errors (still got them)
In-reply-to: <200703042341.38431.s0348365@sms.ed.ac.uk>
To: Alistair John Strachan <s0348365@sms.ed.ac.uk>
Cc: Jeff Garzik <jeff@garzik.org>, linux-kernel@vger.kernel.org
Message-id: <45EB5B0A.3050106@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <200703011339.52895.s0348365@sms.ed.ac.uk>
 <200703021547.09121.s0348365@sms.ed.ac.uk> <45EB555C.9050606@shaw.ca>
 <200703042341.38431.s0348365@sms.ed.ac.uk>
User-Agent: Thunderbird 1.5.0.10 (Windows/20070221)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Alistair John Strachan wrote:
>> Interesting. Can you try un-reverting that patch, and applying this one?
> 
> Sorry for the newbie question, but is it adequate to do a:
> 
> 	git reset --hard v2.6.21-rc2
> 
> To ensure a patch is "unreverted" (I reverted it with "git revert"), before 
> applying your patch?
> 
> I've done so now, assuming this _will_ work. The reason I ask is that your 
> diff was offset by 12 lines versus -rc2.

I assume it's OK, though I'm not a git expert. I diffed against rc2-git3 
which has some CONFIG_PM ifdef changes, those shouldn't be important though.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

