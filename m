Return-Path: <linux-kernel-owner+w=401wt.eu-S1754184AbYHYChS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184AbYHYChS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 22:37:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751143AbYHYChG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 22:37:06 -0400
Received: from rv-out-0506.google.com ([209.85.198.233]:3096 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbYHYChF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 22:37:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=hjckST6v3/0Io+rVsG1pJpnYvPeGnDQ4As7Xc7zIsDh3G9KBkjeseJ3BUxulzqdS5L
         Af3HVH8Itx/tQFtKgM5vB5yepvZpH3CeGjz0bAED7v3YOdjyf7y06RGFvCRYJQb4ops+
         6kH9Ef8zVUTebn919EBe1M6BWggw7FmewxTKA=
Message-ID: <86802c440808241937g1b8822c5r5de75c2a7eb17532@mail.gmail.com>
Date: Sun, 24 Aug 2008 19:37:04 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "David Witbrodt" <dawitbro@sbcglobal.net>
Subject: Re: HPET regression in 2.6.26 versus 2.6.25 -- found another user with the same regression
Cc: "Ingo Molnar" <mingo@elte.hu>,
       "Linux-kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <914225.91320.qm@web82104.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <914225.91320.qm@web82104.mail.mud.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 24, 2008 at 7:00 PM, David Witbrodt <dawitbro@sbcglobal.net> wrote:
>
>
>> after discussing with Ingo, we have one more generic way to detect the
>> same situation.
>>
>> please help to verify the attached patch. ( don't apply previous patch)
>
> Geez, a guy tries to leave so he doesn't get banned because of his stupid
> webmail client, and...  oh, never mind...  ;)
>
>
> Results:
>
> 1) patch applied perfectly to tip/master.
>
> 2) patched file compiles without warning or error.
> (I thought there would be a type mismatch -- the "base" variable in your
> patch is unsigned long, while "res->start" is resource_size_t ==>
> u64 ==> unsigned long long, but I must have been mistaken.)
>
> 3) kernel builds fine
>
> 4) reboot hangs at the familiar call of inet_init()

ok, could be something.

anyway, can you test patch

only_put_e820_ram_in_res_tree.patch

that should be final solution for all.

YH
