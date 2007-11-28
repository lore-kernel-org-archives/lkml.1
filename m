Return-Path: <linux-kernel-owner+w=401wt.eu-S1760511AbXK1ATR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760511AbXK1ATR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2007 19:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754986AbXK1ATF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Nov 2007 19:19:05 -0500
Received: from idcmail-mo1so.shaw.ca ([24.71.223.10]:15551 "EHLO
	pd4mo2so.prod.shaw.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505AbXK1ATE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2007 19:19:04 -0500
Date: Tue, 27 Nov 2007 18:18:58 -0600
From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: Dynticks Causing High Context Switch Rate in ksoftirqd
In-reply-to: <1887.192.128.167.68.1196188273.squirrel@www.techfinesse.net>
To: bdupree@techfinesse.com
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Message-id: <474CB3F2.9020901@shaw.ca>
MIME-version: 1.0
Content-type: text/plain; charset=ISO-8859-1; format=flowed
Content-transfer-encoding: 7bit
References: <fa.c70Wy8WHP3DOaDydQ2D94+Xxx/8@ifi.uio.no>
 <474B9EC1.5020304@shaw.ca>
 <1887.192.128.167.68.1196188273.squirrel@www.techfinesse.net>
User-Agent: Thunderbird 2.0.0.9 (Windows/20071031)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

bdupree@techfinesse.com wrote:
> Hello Robert,
> 
> I've attached additional detail on the config of the misbehaving system
> including output from oprofile and PowerTop. PowerTop output leads me to
> believe that maybe this is an interaction between my bridged ethernet
> setup and dynticks? Hmmm...

Don't know about that, your top wakeups are from br_stp_enable_bridge, 
but that is only 26 a second - that doesn't explain a context switch 
rate of 150,000 a second..

-- 
Robert Hancock      Saskatoon, SK, Canada
To email, remove "nospam" from hancockr@nospamshaw.ca
Home Page: http://www.roberthancock.com/

