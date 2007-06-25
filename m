Return-Path: <linux-kernel-owner+w=401wt.eu-S1755610AbXFYE3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610AbXFYE3b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2007 00:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752535AbXFYE3W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Jun 2007 00:29:22 -0400
Received: from py-out-1112.google.com ([64.233.166.181]:46738 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbXFYE3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2007 00:29:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=c8moSNlGRj5Cx//qukJC8OTD+NYUGeD6UvJDf46iFuE5iJ0F76p03dTCTTnWcWlOEKy+kldJgyOC7fpLfV3pux6LGKPRKbBzVKrw4wfl2if8P60U99ZzeoaBxb++HNM1qTPBAYDzZyV/LwlZB2NSwLl5bk3gWkszC+WZPaj4QJI=
Message-ID: <467F449B.1040200@gmail.com>
Date: Mon, 25 Jun 2007 13:29:15 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Icedove 1.5.0.10 (X11/20070307)
MIME-Version: 1.0
To: Petr Vandrovec <vandrove@vc.cvut.cz>
CC: Robert Hancock <hancockr@shaw.ca>, Jeff Garzik <jeff@garzik.org>,
       Andrew Morton <akpm@linux-foundation.org>, enricoss@tiscali.it,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org
Subject: Re: [PATCH 2.6.22-rc5] libata: add HTS541616J9SA00 to NCQ blacklist
References: <fa.sspu6LOivd/touNtS2IsMKPqHa0@ifi.uio.no> <fa.19XJG1Asdp1zwcWLxolIH6F+5lY@ifi.uio.no> <467EC909.9040006@shaw.ca> <467F2495.3080509@gmail.com> <467F286B.40607@gmail.com> <467F2ADF.1040600@shaw.ca> <467F2D53.2000202@gmail.com> <467F3AE2.7010606@vc.cvut.cz> <467F3EF6.4000907@gmail.com> <467F4031.8000406@shaw.ca> <467F42F3.1000609@vc.cvut.cz>
In-Reply-To: <467F42F3.1000609@vc.cvut.cz>
X-Enigmail-Version: 0.94.2.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Petr Vandrovec wrote:
>>> Hmmm... The last one (HTS541612J9SA00) is taken directly from hdparm
>>> output, and I think I verified the patch with the reporter.  Hmm... Can
>>> anyone verify these module strings?
>>
>> Could well be that they've started attaching Hitachi to the ID strings
>> now.. In the past it hasn't seemed to have been Hitachi's (and IBM's
>> before that) practice to have it there, but maybe they see the
>> advantage of being able to figure out who made the drive now :-)
> 
> Perhaps ones sold directly by Hitachi are Hitachi, while ones sold
> through OEMs are no-name?

I dunno but I doubt they care that much about the model string but one
way or the other we might have to do pattern matching on HTS541* anyway.

-- 
tejun
