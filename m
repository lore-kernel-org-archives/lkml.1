Return-Path: <linux-kernel-owner+w=401wt.eu-S1755436AbZKPXP4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755436AbZKPXP4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Nov 2009 18:15:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755419AbZKPXPz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Nov 2009 18:15:55 -0500
Received: from mail-iw0-f178.google.com ([209.85.223.178]:43008 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755097AbZKPXPy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Nov 2009 18:15:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=umqdBvFWStlrs8RJRP6p1Vk6luOmKJUtITcPBS2hqGhLWFTC7LpApoIchN+vkv3bdg
         M8XyLSFAfc7daNnrOLHQfcPgY9BpWPjjWKKEyclrYxChJT0mAHAZ98b0xIRz+zd1VF4s
         F5jMs/5FU9iRH0egOvXUZ9D9vkRB+NtK1MR5w=
MIME-Version: 1.0
In-Reply-To: <4ADE2F66.1070703@gmail.com>
References: <4ADE2F66.1070703@gmail.com>
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 16 Nov 2009 15:15:39 -0800
Message-ID: <43e72e890911161515q64ff527cyefd7d769f3c501b@mail.gmail.com>
Subject: Re: 2.6.32-rc5-git1 -- BUG kmalloc-8192: Poison overwritten (ath9k 
	implicated)
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       linux-wireless <linux-wireless@vger.kernel.org>,
       Felix Bitterli <ic.felix@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 20, 2009 at 1:45 PM, Miles Lane <miles.lane@gmail.com> wrote:
> Let me know if you want my .config file.  I think this was triggered by
> suspending my laptop.
>
> BUG kmalloc-8192: Poison overwritten

Thanks for your report Miles.

Are you using Linus' tree? Felix wrote some patches that got rid of
the rate control private area which we kmalloc/kfree and at least one
user reported that these patches fixed a memory leak. I'm curious if
the same patches would resolve this issue.

Only thing is these patches apply against wireless-testing and not
2.6.32. To test them you'd have to pull wireless-testing master to
your tree and then apply the patches both before and after.

Would you be up to try that?

   Luis
