Return-Path: <linux-kernel-owner+w=401wt.eu-S1753244AbZHJJTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753244AbZHJJTm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Aug 2009 05:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753209AbZHJJTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 10 Aug 2009 05:19:41 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:44582 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753142AbZHJJTl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Aug 2009 05:19:41 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=ayTspesLy0yCAH5mNebeomrGNHQ6UgNBneC9RMMcHa2qaLC1pM5OGu6HpomJFR0GoK
         cjqRa/Rn0eSBc1cYL31G6YIIDaiepT4UO4n/4EwexK2nOVmXZPEt+laV3DKu5pNIOiAE
         n0fQ308whwYa656O3O3vjhtRvLpxCNlurfd5E=
MIME-Version: 1.0
In-Reply-To: <1249895639.4919.133.camel@macbook.infradead.org>
References: <3877989d0907310129p29dd5039p18563946b9be8099@mail.gmail.com>
	 <1249369794.9324.18.camel@macbook.infradead.org>
	 <3877989d0908092321h56afcc7ve9fe39fa68f42a48@mail.gmail.com>
	 <1249895639.4919.133.camel@macbook.infradead.org>
Date: Mon, 10 Aug 2009 17:19:41 +0800
Message-ID: <3877989d0908100219p51c39004gb40b63cd88735e97@mail.gmail.com>
Subject: Re: [RFC patch] return early if all dmar HW unit ignored
From: Luming Yu <luming.yu@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 10, 2009 at 5:13 PM, David Woodhouse<dwmw2@infradead.org> wrote:
> On Mon, 2009-08-10 at 14:21 +0800, Luming Yu wrote:
>>
>> But I don't know why I were seeing faults if all dmar units were
>> ignored? Surely that shouldn't happen? Will double check and
>> investigate.
>
> It shouldn't happen -- I suspect that you didn't actually mark them
> _all_ ignored? What happens if you modify my patch just to mark the
> offending unit as ignored, but don't also apply your patch? Does it boot
> then?

Just with your patch, it boot without any problem.
Add my patch in the thread, it boots too, and I see total 4 entries parsed...
