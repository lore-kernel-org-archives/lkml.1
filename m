Return-Path: <linux-kernel-owner+w=401wt.eu-S933788AbXGYRP6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933788AbXGYRP6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2007 13:15:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760373AbXGYRPv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 25 Jul 2007 13:15:51 -0400
Received: from wa-out-1112.google.com ([209.85.146.183]:28345 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354AbXGYRPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2007 13:15:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Nn22iYY2PveTvkFSXyiWKJzjJmwPK5/I3sPVvEmb8T7de4SUUSjFv6xuHfQjVJmZtFMbNjuT0Vh90RmcRYOVW1Z3dIi/7ed+JvzvmiDNXve3Djg6cp0lj2mT9QmUpglzO4dpsFWfuY4diQaiao2eLxIiRquVppTXsl/SYvC1gEI=
Message-ID: <a491f91d0707251015x75404d9fld7b3382f69112028@mail.gmail.com>
Date: Wed, 25 Jul 2007 13:15:49 -0400
From: "Robert Deaton" <false.hopes@gmail.com>
To: "Rene Herman" <rene.herman@gmail.com>
Subject: Re: howto get a patch merged (WAS: Re: -mm merge plans for 2.6.23)
Cc: linux-kernel@vger.kernel.org, "ck list" <ck@vds.kolivas.org>,
       linux-mm@kvack.org
In-Reply-To: <46A773EA.5030103@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <367a23780707250830i20a04a60n690e8da5630d39a9@mail.gmail.com>
	 <46A773EA.5030103@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/25/07, Rene Herman <rene.herman@gmail.com> wrote:
> And there we go again -- off into blabber-land. Why does swap-prefetch help
> updatedb? Or doesn't it? And if it doesn't, why should anyone trust anything
> else someone who said it does says?

I don't think anyone has ever argued that swap-prefetch directly helps
the performance of updatedb in any way, however, I do recall people
mentioning that updatedb, being a ram intensive task, will often cause
things to be swapped out while it runs on say a nightly cronjob. If a
person is not at their computer, updatedb will run, cause all their
applications to be swapped out, finish its work, and exit, leaving all
the other applications that would have otherwise been left in RAM for
when the user returns to his/her computer in swap. Thus, when someone
returns, you have to wait for all your applications to be swapped back
in.

Swap prefetch, on the other hand, would have kicked in shortly after
updatedb finished, leaving the applications in swap for a speedy
recovery when the person comes back to their computer.

-- 
--Robert Deaton
