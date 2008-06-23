Return-Path: <linux-kernel-owner+w=401wt.eu-S1762402AbYFWSRW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762402AbYFWSRW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2008 14:17:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755594AbYFWSRO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 23 Jun 2008 14:17:14 -0400
Received: from el-out-1112.google.com ([209.85.162.176]:7217 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754172AbYFWSRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2008 14:17:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=FHzDd3hXnbwqIQCskgtu8OJi1GqyPTkxI/2jg0atTENZyQG7Ap2FPoF6X0Bc5X30qb
         cXW8AMszn2H5+397SlDGnt9nQucLklPgakpmeyRqmEsfzuoXuIhR2HAnLAjDk0NjV1zc
         Fbq1J63mAnk2dJbIDEJ099tmDpmrNH/zGrSn8=
Message-ID: <6278d2220806231117v551d93f1o7ecb5c7558a62b96@mail.gmail.com>
Date: Mon, 23 Jun 2008 19:17:11 +0100
From: "Daniel J Blueman" <daniel.blueman@gmail.com>
To: "Ian Soboroff" <isoboroff@gmail.com>
Subject: Re: Oops in NFS (RHEL4, but also in kernel bugzilla)
Cc: "Linux Kernel" <linux-kernel@vger.kernel.org>
In-Reply-To: <9cfod5sayiq.fsf@rogue.ncsl.nist.gov>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <6278d2220806181933l74719bdbkea02f697ee424157@mail.gmail.com>
	 <9cfod5sayiq.fsf@rogue.ncsl.nist.gov>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 5:47 PM, Ian Soboroff <isoboroff@gmail.com> wrote:
> The following message is a courtesy copy of an article
> that has been posted to gmane.linux.kernel as well.
>
> "Daniel J Blueman" <daniel.blueman@gmail.com> writes:
>
>> Has 4KB stacks been disabled? You can check the config file for
>> CONFIG_4KSTACKS.
>
> This kernel has 4KSTACKS enabled.

There is chance that you've overrun the 4KB stack. Can you retest with
CONFIG_4KSTACK disabled perhaps?

>> It may also be worth feeding that into the bugzilla entry, to
>> eliminate one possibility, as 'bad EIP value' looks suspicious of
>> stack corrption.
>
> Ok, will do.  Although that bugzilla entry is from 2007 and no one seems
> to have looked at it at all...
-- 
Daniel J Blueman
