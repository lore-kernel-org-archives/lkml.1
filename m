Return-Path: <linux-kernel-owner+w=401wt.eu-S1030363AbXCSQhi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030363AbXCSQhi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2007 12:37:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030368AbXCSQhi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 19 Mar 2007 12:37:38 -0400
Received: from il.qumranet.com ([82.166.9.18]:60163 "EHLO il.qumranet.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030363AbXCSQhi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2007 12:37:38 -0400
Message-ID: <45FEBC51.6060707@argo.co.il>
Date: Mon, 19 Mar 2007 18:37:37 +0200
From: Avi Kivity <avi@argo.co.il>
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Helge Hafting <helge.hafting@aitel.hist.no>
CC: davids@webmaster.com,
       "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: Re: is RSDL an "unfair" scheduler too?
References: <MDEHLPKNGKAHNMBLJOLKGEMBCFAC.davids@webmaster.com> <45FEAB60.7090704@argo.co.il> <45FEB50E.2040104@aitel.hist.no>
In-Reply-To: <45FEB50E.2040104@aitel.hist.no>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Helge Hafting wrote:
> Avi Kivity wrote:
>>
>> A fairly contrived example, but I see your point.  Of course any 
>> system can be broken.  I think that user-level scheduling is good for 
>> real multi user systems, where 'user' means a person, not an 
>> artificial entity.  It's also good for a multi application server, 
>> where typically each service runs (or can be made to run) as a 
>> separate user.
> For a not so contrived example, look at email delivery.  Some 
> mailservers do
> all work as root (or some fixed email user)
>
> Some servers will switch to the UID of the user receiving the message, 
> limiting the
> damage in case of buffer overflow etc. A fair amount of work is then done
> as that user - running the message through virus/spam-checks and
> then perhaps procmail.
>

Actually that makes some sense with user level scheduling - delivering 
email is charged to the recipient instead of to the system.  But I agree 
it's a surprising side effect and if this is ever implemented it should 
be optional.

-- 
error compiling committee.c: too many arguments to function

