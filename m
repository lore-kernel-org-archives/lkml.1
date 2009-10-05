Return-Path: <linux-kernel-owner+w=401wt.eu-S1754051AbZJEU1c@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754051AbZJEU1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Oct 2009 16:27:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753199AbZJEU1b
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Oct 2009 16:27:31 -0400
Received: from mail-yw0-f176.google.com ([209.85.211.176]:49326 "EHLO
	mail-yw0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbZJEU1b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Oct 2009 16:27:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=vE9pG4s7wDHbbb2+DGGIstXv+sLIU1iOZabv78IJgVfs2vM+daXnMdutcb6rwITF51
         ab0u4jYoZ/Iub4vLJ3ohidtmH7TioqULeAE1SHR3IiLqQE63ND3uz0l/r1RnCAuSsEWm
         0qeZtI1a4+7Kzve24tbQJ/u4ht4bEbo6DU83o=
MIME-Version: 1.0
In-Reply-To: <4e5e476b0910050808k3a26aad8r19a145fc60e1da6b@mail.gmail.com>
References: <4e5e476b0910041354o54c95626g974264976adaf53c@mail.gmail.com>
	 <20091004205955.GM26573@kernel.dk>
	 <4e5e476b0910050808k3a26aad8r19a145fc60e1da6b@mail.gmail.com>
Date: Mon, 5 Oct 2009 22:26:52 +0200
Message-ID: <4e5e476b0910051326g559bf135ma3cf82219ade497@mail.gmail.com>
Subject: Re: bug in elevator/cfq regarding start_time?
From: Corrado Zoccolo <czoccolo@gmail.com>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Linux-Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 5, 2009 at 5:08 PM, Corrado Zoccolo <czoccolo@gmail.com> wrote:
> On Sun, Oct 4, 2009 at 10:59 PM, Jens Axboe <jens.axboe@oracle.com> wrote:
>> Good spotting! So we can either add the same copy in cfq, or we can just
>> move the ->start_time check and assignment in attempt_merge() to post
>> the elv_merge_requests() call. I think the latter would work fine, but
>> I'll check and fix tomorrow.
>
> I think there is still something buggy regarding those timestamps.
False alarm. I just found that the list was not yet filled at that
place in the code.

Corrado
