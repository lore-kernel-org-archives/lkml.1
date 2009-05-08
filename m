Return-Path: <linux-kernel-owner+w=401wt.eu-S1762536AbZEHQYA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762536AbZEHQYA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 May 2009 12:24:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755161AbZEHQXs
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 May 2009 12:23:48 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:10712 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140AbZEHQXr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 May 2009 12:23:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=redi6AtslOsTmxef82Zd1MxBiGV+MeF5XalrekLA0n5ItQFO17YXtPSgTZp3lSiMqg
         rzUH6jyLfqt3xdqrZCmeiYLwnWOk0IW5GxILYnEp5hFrWaF9sRiY0NnUjZ7RNBApaQZZ
         9xgH8KwOZ1Kp7MUWLDBvwDRt3I4rV0FKMnuy8=
MIME-Version: 1.0
In-Reply-To: <4A03F7A8.9090204@kernel.org>
References: <1233456951-992-1-git-send-email-tj@kernel.org>
	 <49F902CF.7080307@garzik.org> <49F903DD.8040707@kernel.org>
	 <49FA0349.3090706@garzik.org>
	 <e9c3a7c20904301415t621670a0l1bd64c7d74d369f@mail.gmail.com>
	 <49FEA127.1000905@kernel.org>
	 <e9c3a7c20905040948m572e23dj1aa197dbd20ff037@mail.gmail.com>
	 <49FFB275.7000507@kernel.org>
	 <e9c3a7c20905050834t79a1c03dt83df288b2f38ed76@mail.gmail.com>
	 <4A03F7A8.9090204@kernel.org>
Date: Fri, 8 May 2009 09:23:46 -0700
Message-ID: <e9c3a7c20905080923u12c2eddaq92012e919d52e784@mail.gmail.com>
Subject: Re: [PATCHSET] block,scsi,libata: implement alt_size
From: Dan Williams <dan.j.williams@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org,
       jens.axboe@oracle.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org, James.Bottomley@hansenpartnership.com,
       Mauelshagen@redhat.com, device-mapper development <dm-devel@redhat.com>,
       heinzm@redhat.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ added heinzm@redhat.com ]

On Fri, May 8, 2009 at 2:13 AM, Tejun Heo <tj@kernel.org> wrote:
> Dan Williams wrote:
>> On Mon, May 4, 2009 at 8:28 PM, Tejun Heo <tj@kernel.org> wrote:
>>> Pushing this in the kernel without updating dm-raid is kind of
>>> pointless.  Who should I be poking to get the userland part moving?
>>
>> Dmraid is not the only potential user.  Mdadm will also care about
>> this as I have seen a report that points to a user having what looks
>> like an HPA issue with an Intel(R) Matrix array.  So, there are two
>> immediate users for this interface.  Heinz is the right person to poke
>> for dmraid updates.  I'll handle the mdadm update.
>
> Alright, then.  With Jeff's reluctant ack and scheduled mdadm update,
> I guess this one can go upstream.  I'll refresh the patchset and
> repost.  Umm... BTW do I have Heinz's mail address right?

Heinz, here is the whole thread:

http://marc.info/?t=123345711600004&r=1&w=2
