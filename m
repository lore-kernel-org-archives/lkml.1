Return-Path: <linux-kernel-owner+w=401wt.eu-S1751553AbYF3Cum@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751553AbYF3Cum (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Jun 2008 22:50:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754515AbYF3Cu2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 29 Jun 2008 22:50:28 -0400
Received: from srv5.dvmed.net ([207.36.208.214]:59265 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754496AbYF3Ctk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Jun 2008 22:49:40 -0400
Message-ID: <486849C0.7050703@garzik.org>
Date: Sun, 29 Jun 2008 22:49:36 -0400
From: Jeff Garzik <jeff@garzik.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@computergmbh.de>
CC: Linux Kernel <linux-kernel@vger.kernel.org>,
       Git Mailing List <git@vger.kernel.org>
Subject: Re: Updated Kernel Hacker's guide to git
References: <200612241807.kBOI746w008739@laptop13.inf.utfsm.cl> <476E42BF.1010300@garzik.org> <Pine.LNX.4.64.0712310349260.2093@fbirervta.pbzchgretzou.qr>
In-Reply-To: <Pine.LNX.4.64.0712310349260.2093@fbirervta.pbzchgretzou.qr>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Score: -4.4 (----)
X-Spam-Report: SpamAssassin version 3.2.4 on srv5.dvmed.net summary:
	Content analysis details:   (-4.4 points, 5.0 required)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jan Engelhardt wrote:
> On Dec 23 2007 06:13, Jeff Garzik wrote:
>> Another year, another update!  :)
>>
>> The kernel hacker's guide to git has received some updates:
>>
>> 	http://linux.yyz.us/git-howto.html
>>
> 
> It says
> 
> """Don't forget to download tags from time to time.
> 
> git pull only downloads sha1-indexed object data, and the requested
> remote head. This misses updates to the .git/refs/tags/ and
> .git/refs/heads/ directories. For tags, run git fetch --tags $URL."""
> 
> 
> But when I do git pull on a simple tracking tree (e.g. git-clone
> torvalds/linux-2.6.git; git pull;) it automatically grabs new tags.



Unfortunately tags are not copied in all cases.  To this day, I still 
have to 'git fetch --tags', generally when pulling from one local repo 
into another.  It's annoying that tags don't follow objects, when pulled.

	Jeff


