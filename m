Return-Path: <linux-kernel-owner+w=401wt.eu-S1757311AbYH3JQD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757311AbYH3JQD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Aug 2008 05:16:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750878AbYH3JPu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 30 Aug 2008 05:15:50 -0400
Received: from hera.kernel.org ([140.211.167.34]:49862 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750808AbYH3JPu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Aug 2008 05:15:50 -0400
Message-ID: <48B90F7F.8040308@kernel.org>
Date: Sat, 30 Aug 2008 11:14:39 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Re: SATA Cold Boot problems on >2.6.25 with NV
References: <fa.CVrJhjm3R8sjl5Z+EEIzYm7QtW0@ifi.uio.no> <48B80B40.5060002@shaw.ca> <48B80D33.5050806@gmail.com> <20080829212146.GA4321@anita>
In-Reply-To: <20080829212146.GA4321@anita>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Sat, 30 Aug 2008 09:15:49 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Konstantin Kletschke wrote:
> Am 2008-08-29 16:52 +0200 schrieb Tejun Heo:
> 
>>   http://article.gmane.org/gmane.linux.ide/34077
> 
> I have this patch actually applied and had switched off the computer
> afterwards completely for more than one hour two times. Each time it
> booted then (this was the patch you suggested initially to Many Maxwell
> this month to this list).
> 
> Everything seems to work fine, but my dmesg and /var/log/messages is
> flooded with this now:
> 
> Aug 29 23:20:39 zappa ata1: EH complete
> Aug 29 23:20:41 zappa ata1: EH complete
> Aug 29 23:20:47 zappa ata1: EH complete
> Aug 29 23:20:49 zappa ata1: EH complete
> Aug 29 23:20:51 zappa ata1: EH complete
> Aug 29 23:20:53 zappa ata1: EH complete
> Aug 29 23:20:55 zappa ata1: EH complete
> Aug 29 23:20:56 zappa ata1: EH complete
> Aug 29 23:20:59 zappa ata1: EH complete
> Aug 29 23:21:01 zappa ata1: EH complete

Hmm... Can you post full dmesg output?  We used to see things like above
when ATAPI CHECK SENSE handling somehow failed to tell EH that it was an
exception not worth whining about.  Maybe EH action mask is not being
cleared properly?

> I am curious if it boots tomorrow after sleeping for one night :-P

I somehow feel pretty optimistic about that part.  :-)

-- 
tejun
