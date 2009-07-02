Return-Path: <linux-kernel-owner+w=401wt.eu-S1752263AbZGBJoU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752263AbZGBJoU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jul 2009 05:44:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751171AbZGBJoM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 2 Jul 2009 05:44:12 -0400
Received: from mail-px0-f190.google.com ([209.85.216.190]:40533 "EHLO
	mail-px0-f190.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059AbZGBJoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jul 2009 05:44:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=D8uu18N7DJY6fAY8/LDb1/ZJJ32GoeAmXYOZRlp7x3t32RafzgnVs2oDMxpQkzunz4
         unXWC0momYnyoB2Qh7lF6iqTngeyeEkySQ5ePvm5F4QBFEntaGUiBb/nwTOdQz8hRlfp
         gC5To1QH8afTwGCJyuzSxwvIAuque/g4aa+Hc=
Date: Thu, 2 Jul 2009 17:46:20 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Changli Gao <xiaosuo@gmail.com>
Cc: Amerigo Wang <xiyou.wangcong@gmail.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: PROPOSAL: extend pipe() to support NULL argument.
Message-ID: <20090702094620.GE6372@cr0.nay.redhat.com>
References: <412e6f7f0907020036y76abbc7du99c7b695f725be4@mail.gmail.com> <20090702091309.GB6372@cr0.nay.redhat.com> <412e6f7f0907020218m1f4a9651l2c682a9905925bcd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <412e6f7f0907020218m1f4a9651l2c682a9905925bcd@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 02, 2009 at 05:18:49PM +0800, Changli Gao wrote:
>On Thu, Jul 2, 2009 at 5:13 PM, Amerigo Wang<xiyou.wangcong@gmail.com> wrote:
>> On Thu, Jul 02, 2009 at 03:36:41PM +0800, Changli Gao wrote:
>>
>> Why? Why do you need this feature?
>>
>Are you familiar with splice() and tee()? They both use pipes as kernel buffers.

You are not answering the question, obviously.

And you snipped too much, how can you return that fd? Using the return value?
Ah! This will probably break the user-space program...
