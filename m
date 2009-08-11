Return-Path: <linux-kernel-owner+w=401wt.eu-S1753622AbZHKNaI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753622AbZHKNaI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 09:30:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753375AbZHKNaH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 09:30:07 -0400
Received: from mail-pz0-f196.google.com ([209.85.222.196]:37222 "EHLO
	mail-pz0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394AbZHKNaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 09:30:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=W0161yOE5K1Syz/N76ScE1UqaRk0YrZM02HCfMAMTohdRMcNt15A0qESuOfbwhCEdM
         /HZ3RmgO+8goDH67tLiw8YyoIV+EhykHFleZKKh5zZZzMcx4Uyw7E+ahy0huj5t+Tr4j
         XlQh/Ove//yn8TQcZe7QSOP0T+AfF3z6XNIRk=
MIME-Version: 1.0
In-Reply-To: <3877989d0908100222r3884f85ci6b993c53dec423ec@mail.gmail.com>
References: <3877989d0907310129p29dd5039p18563946b9be8099@mail.gmail.com>
	 <1249369794.9324.18.camel@macbook.infradead.org>
	 <3877989d0908092321h56afcc7ve9fe39fa68f42a48@mail.gmail.com>
	 <1249895639.4919.133.camel@macbook.infradead.org>
	 <3877989d0908100219p51c39004gb40b63cd88735e97@mail.gmail.com>
	 <3877989d0908100222r3884f85ci6b993c53dec423ec@mail.gmail.com>
Date: Tue, 11 Aug 2009 10:47:31 +0800
Message-ID: <3877989d0908101947o49a58e4ao2590f3fc6889e337@mail.gmail.com>
Subject: Re: [RFC patch] return early if all dmar HW unit ignored
From: Luming Yu <luming.yu@gmail.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> It shouldn't happen -- I suspect that you didn't actually mark them

if it happens, it means there are bugs in code of handling ignore flag.

>>> _all_ ignored? What happens if you modify my patch just to mark the
>>> offending unit as ignored, but don't also apply your patch? Does it boot
> I guess no but will check for sure tomorrow.

Tested it didn't boot.
