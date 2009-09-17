Return-Path: <linux-kernel-owner+w=401wt.eu-S1756749AbZIQNco@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756749AbZIQNco (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Sep 2009 09:32:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754494AbZIQNco
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Sep 2009 09:32:44 -0400
Received: from rtr.ca ([76.10.145.34]:57334 "EHLO mail.rtr.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398AbZIQNcm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Sep 2009 09:32:42 -0400
Message-ID: <4AB23A7D.4050102@rtr.ca>
Date: Thu, 17 Sep 2009 09:32:45 -0400
From: Mark Lord <liml@rtr.ca>
Organization: Real-Time Remedies Inc.
User-Agent: Thunderbird 2.0.0.23 (X11/20090817)
MIME-Version: 1.0
To: Chris Webb <chris@arachsys.com>
Cc: Tejun Heo <teheo@suse.de>, linux-scsi@vger.kernel.org,
       Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>,
       NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org,
       IDE/ATA development list <linux-ide@vger.kernel.org>,
       Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
Subject: Re: MD/RAID time out writing superblock
References: <4A9BBC4A.6070708@redhat.com> <4A9BC023.10903@kernel.org> <20090907114442.GG18831@arachsys.com> <20090907115927.GU8710@arachsys.com> <20090909120218.GB21829@arachsys.com> <4AADF3C4.5060004@kernel.org> <4AADF471.2020801@suse.de> <4AAE3B9A.2060306@rtr.ca> <4AAE3F86.8090804@suse.de> <4AAE524C.2030401@rtr.ca> <20090916231921.GL1924@arachsys.com> <4AB239C8.2020203@rtr.ca>
In-Reply-To: <4AB239C8.2020203@rtr.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Lord wrote:
>
> Is this still happening from time to time now?
> If so, disable the smartmontools daemon (smartd) and see if the problem 
> goes away.
> And especially disable hddtemp (which issues SMART commands) if that is 
> also around.
> 
> It would be good to discover if those are the triggers for what's 
> happening here.
..

Ah.. I've just now read your other recent posting, so no need to answer again here.



> Tejun.. do we do a FLUSH CACHE before issuing a non-NCQ command ?
> If not, then I think we may need to add code to do it.

