Return-Path: <linux-kernel-owner+w=401wt.eu-S1754737AbYEZHvh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754737AbYEZHvh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 May 2008 03:51:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752924AbYEZHv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 26 May 2008 03:51:26 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:43601 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752753AbYEZHvZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 May 2008 03:51:25 -0400
Message-ID: <483A6BFB.1080209@garzik.org>
Date: Mon, 26 May 2008 03:51:23 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Evgeniy Polyakov <johnpol@2ka.mipt.ru>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: POHMELFS high performance network filesystem. Cache coherency,
 transactions, parallels.
References: <20080525134055.GA30630@2ka.mipt.ru> <483A0F3B.9060709@garzik.org> <20080526062204.GA16366@2ka.mipt.ru> <483A59D7.7020306@garzik.org> <20080526070708.GB16366@2ka.mipt.ru> <483A667F.7070707@garzik.org> <20080526074424.GA555@2ka.mipt.ru>
In-Reply-To: <20080526074424.GA555@2ka.mipt.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Evgeniy Polyakov wrote:
> On Mon, May 26, 2008 at 03:27:59AM -0400, Jeff Garzik (jeff@garzik.org) wrote:
>> git-update-server-info needs to be run on the server, not the client.
>>
>> You can automate this by running this on the server:
>>
>> 	chmod +x .git/hooks/post-update
>>
>> so that git-update-server-info always runs on the server, after each push.
>>
>> See git-update-server-info(1) for more info.
> 
> Hmm... Nothing can be run on server, since git does not believe it is in
> git repo:

Sorry, I should have mentioned, you need to set GIT_DIR environment 
variable, for this case.  e.g.

	cd /home/s0mbre/archive/pohmelfs
	GIT_DIR=pohmelfs.git git-update-server-info

or

	cd /home/s0mbre/archive/pohmelfs/pohmelfs.git
	GIT_DIR=. git-update-server-info

Regards,

	Jeff


