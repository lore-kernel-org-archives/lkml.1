Return-Path: <linux-kernel-owner+w=401wt.eu-S1759789AbZEHJN2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759789AbZEHJN2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 05:13:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754080AbZEHJNM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 05:13:12 -0400
Received: from hera.kernel.org ([140.211.167.34]:53835 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752422AbZEHJNL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 05:13:11 -0400
Message-ID: <4A03F7A8.9090204@kernel.org>
Date: Fri, 08 May 2009 18:13:12 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Dan Williams <dan.j.williams@gmail.com>
CC: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       Mauelshagen@redhat.com, dm-devel@redhat.com
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
References: <1233456951-992-1-git-send-email-tj@kernel.org>	 <49F902CF.7080307@garzik.org> <49F903DD.8040707@kernel.org>	 <49FA0349.3090706@garzik.org>	 <e9c3a7c20904301415t621670a0l1bd64c7d74d369f@mail.gmail.com>	 <49FEA127.1000905@kernel.org>	 <e9c3a7c20905040948m572e23dj1aa197dbd20ff037@mail.gmail.com>	 <49FFB275.7000507@kernel.org> <e9c3a7c20905050834t79a1c03dt83df288b2f38ed76@mail.gmail.com>
In-Reply-To: <e9c3a7c20905050834t79a1c03dt83df288b2f38ed76@mail.gmail.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.0 (hera.kernel.org [127.0.0.1]); Fri, 08 May 2009 09:12:01 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Williams wrote:
> On Mon, May 4, 2009 at 8:28 PM, Tejun Heo <tj@kernel.org> wrote:
>> Pushing this in the kernel without updating dm-raid is kind of
>> pointless.  Who should I be poking to get the userland part moving?
> 
> Dmraid is not the only potential user.  Mdadm will also care about
> this as I have seen a report that points to a user having what looks
> like an HPA issue with an Intel(R) Matrix array.  So, there are two
> immediate users for this interface.  Heinz is the right person to poke
> for dmraid updates.  I'll handle the mdadm update.

Alright, then.  With Jeff's reluctant ack and scheduled mdadm update,
I guess this one can go upstream.  I'll refresh the patchset and
repost.  Umm... BTW do I have Heinz's mail address right?

Thanks.

-- 
tejun
