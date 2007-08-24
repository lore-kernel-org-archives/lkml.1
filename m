Return-Path: <linux-kernel-owner+w=401wt.eu-S1764914AbXHXXUU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764914AbXHXXUU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2007 19:20:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755592AbXHXXUI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Aug 2007 19:20:08 -0400
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:27253 "EHLO
	pd3mo1so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208AbXHXXUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2007 19:20:07 -0400
Date: Fri, 24 Aug 2007 17:19:45 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: USB Key light on/off state depending on mount
In-reply-to: <fa.BwCgwGvTNIOD+KEeBrvP11xCEmw@ifi.uio.no>
To: Casey Dahlin <cjdahlin@ncsu.edu>
Cc: linux-kernel@vger.kernel.org
Message-id: <46CF6791.8040509@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.BwCgwGvTNIOD+KEeBrvP11xCEmw@ifi.uio.no>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Casey Dahlin wrote:
> Most USB keys nowadays have a small LED somewhere inside of them that 
> lights up when they are plugged in. On a windows box, the key is lit up 
> whenever it is mounted, and as soon as it is unmounted it turns off, 
> giving a handy physical indicator that the key is safe to remove. On 
> linux, the light is simply on whenever the key is plugged in.
> 
> Should linux toggle the light depending on mount state? Is it as trivial 
> as it seems or does this reflect some larger issue?

I think that Windows turns off power to the port when you do the "safely 
remove hardware" on it, or something like that. Mount/unmount doesn't 
really indicate whether the device is in use in Linux, though, since it 
can still be potentially accessed even when the device isn't mounted.

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

