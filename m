Return-Path: <linux-kernel-owner+w=401wt.eu-S1761220AbYHRTlT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761220AbYHRTlT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Aug 2008 15:41:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932600AbYHRThv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Aug 2008 15:37:51 -0400
Received: from yx-out-2324.google.com ([74.125.44.30]:15599 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764473AbYHRThs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Aug 2008 15:37:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:reply-to:user-agent:mime-version:to:subject
         :references:in-reply-to:content-type:content-transfer-encoding:from;
        b=hHJKMhVqcRHVyKZoTl13Fcx2BPwZgFBIEhhkuH0bT4QcTyh09muEa1zVSv+dfr3ioD
         SmDDHpGYnO9pDyjV/zaDsbeFFbstPP8xeANRoM9gS3hRShhLMX0h8pFJ5QuOUtYAYzoo
         QAlQNxROdBHS25Iilhp4ebtgt/KbWVeeR7wGw=
Message-ID: <48A9CF89.9090304@bellsouth.net>
Date: Mon, 18 Aug 2008 14:37:45 -0500
Reply-To: jacliburn@bellsouth.net
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Grant Coady <gcoady.lk@gmail.com>,
       linux-kernel <linux-kernel@vger.kernel.org>, neilb@suse.de,
       bfields@fieldses.org, linux-nfs@vger.kernel.org
Subject: Re: NFS regression?  Odd delays and lockups accessing an NFS export.
References: <p6lha4te54h04qdbnos1mcemdmn1cfca6s@4ax.com> <20080818185048.GO20684@miggy.org>
In-Reply-To: <20080818185048.GO20684@miggy.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
From: "J. K. Cliburn" <jcliburn@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Athanasius wrote:
> On Mon, Aug 18, 2008 at 12:02:20PM +1000, Grant Coady wrote:
>> I've been using NFS here for years, lately there's something odd going on 
>> since about a month or so.  Previously reported last month:
>> http://www.gossamer-threads.com/lists/linux/kernel/951419?page=last
>>
>> Now with 2.6.27-rc3 on one of the client boxes I get a complete stall 
>> at odd times when accessing the server's exported directory, cannot 
>> see a pattern to it.  Eventually recovers after a Ctrl-C.  Nothing in 
>> the server or client log files.  Not easy to reproduce either.
> 
>   I wonder if this is what I've been seeing.  I've been otherwise too
> busy to properly report it, thinking that *someone* else must also be
> seeing it and it's being worked on, else it's a subtle configuration
> problem my end.
> 
>   I first started seeing this with 2.6.26 on the client end, 

I see you're running the atl1 driver on your client.  I'm chasing an 
intermittent bug in that driver that seems to be affected by certain 
offload parameters.  Try disabling TSO and see if things improve.

ethtool -K eth0 tso off

Let me know if it helps.

Jay
