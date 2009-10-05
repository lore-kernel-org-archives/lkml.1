Return-Path: <linux-kernel-owner+w=401wt.eu-S1754646AbZJEUCL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754646AbZJEUCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 16:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752404AbZJEUCL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 16:02:11 -0400
Received: from mail-ew0-f217.google.com ([209.85.219.217]:64153 "EHLO
	mail-ew0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430AbZJEUCK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 16:02:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=CNs46Rwg0zQWCpOC+qZenxGARax6K1CWy4hNfqhpu1ZK+4HZo7bNubtzXW3r19LpfI
         7O5AiUaQGxN2bZly7oC9WLyrIZOfHfPDJ9fYI5/aurDXoWci9GyVUcDd3Dz4vf71IwgX
         6260H8OPcef+QHboIaj5/Md+k+CN1Pjd2l8/U=
Message-ID: <4ACA50DD.9050801@tuffmail.co.uk>
Date: Mon, 05 Oct 2009 21:02:37 +0100
From: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Stefan Seyfried <stefan.seyfried@googlemail.com>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>,
       pm list <linux-pm@lists.linux-foundation.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] 2.6.32-rc1: various BUGs on resume from hibernation
References: <4AC8B4A8.3050601@tuffmail.co.uk>	<4AC8D568.9090103@tuffmail.co.uk>	<200910042247.43528.rjw@sisk.pl> <20091005095327.5ea9831b@strolchi>
In-Reply-To: <20091005095327.5ea9831b@strolchi>
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Seyfried wrote:
> On Sun, 4 Oct 2009 22:47:43 +0200
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
>   
>> On Sunday 04 October 2009, Alan Jenkins wrote:
>>     
>>> Alan Jenkins wrote:
>>>       
>>>> I'm seeing a variety of BUGs on my EeePC 701 after hibernation.  
>>>> Sometimes they cause a hang during resume; sometimes they happen
>>>> just after resume.  It doesn't happen all the time either -  I've
>>>> just hibernated three times in a row with no problems.  It's most
>>>> perplexing.
>>>>         
>
>   
>> As I already asked in the Bugzilla, can you verify that this is
>> reproducible without KMS?
>>     

No. I couldn't reproduce it without KMS. Then I re-enabled KMS, 
hibernated a couple of times, and had another resume hang (different 
again - this time in the freezer).

