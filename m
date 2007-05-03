Return-Path: <linux-kernel-owner+w=401wt.eu-S1767543AbXECRjV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767543AbXECRjV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2007 13:39:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767553AbXECRjV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 3 May 2007 13:39:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40213 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1767543AbXECRi5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2007 13:38:57 -0400
Message-ID: <463A1CD3.2060200@redhat.com>
Date: Thu, 03 May 2007 13:33:07 -0400
From: =?UTF-8?B?S3Jpc3RpYW4gSMO4Z3NiZXJn?= <krh@redhat.com>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Adrian Bunk <bunk@stusta.de>
CC: Stefan Richter <stefanr@s5r6.in-berlin.de>, Olaf Hering <olh@suse.de>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       linux1394-devel@lists.sourceforge.net, akpm@linux-foundation.org,
       torvalds@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [git pull] New firewire stack
References: <200705030004.l4304l8h012587@turbo.physics.adelaide.edu.au> <46399BDE.4040605@s5r6.in-berlin.de> <20070503114854.GA12731@suse.de> <4639E3FC.8060107@s5r6.in-berlin.de> <20070503163442.GK3531@stusta.de>
In-Reply-To: <20070503163442.GK3531@stusta.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Adrian Bunk wrote:
>> | An advantage of changing the names is that they are now prefixed.
>>
>> Is the opportunity to clean up module names compelling enough, vs. (the
>> wish for) minimized trouble with scripts which refer to module names?
>> ...
> 
> How big is the trouble actually?

Exactly.  In Fedora we've just added a fw-sbp2 case to mkinitrd, it's only a 
couple of lines of extra shell code:

     elif [ "$modName" = "fw-sbp2" ]; then
         findmodule fw-core
         findmodule fw-ohci
         modName="fw-sbp2"

and that's the extent of the changes.  The sbp2 case for the old drivers is 
still in there and in the end mkinitrd works with either stack.

Kristian

