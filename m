Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbYIHAPB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbYIHAPB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Sep 2008 20:15:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750791AbYIHAOw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 7 Sep 2008 20:14:52 -0400
Received: from rv-out-0506.google.com ([209.85.198.235]:48661 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750783AbYIHAOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Sep 2008 20:14:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BDHJlDhgdQQEXs+5akgjAPfeBHGwK1RcvhlkRjvq0EcZXoxDE2RjrXEJBG8Jc/ETTi
         WqHsH1PTSlu7c/CaU2LkibilrCcbQ8IJuQhZ3xzEL+At/QxVXLxxLze3JooHD0sInBWj
         Y1J5313yFUlN2C2gEqKtVHfbolowh5RQ1lxDw=
Message-ID: <86802c440809071714g63fb18c8xd78d8d555f456176@mail.gmail.com>
Date: Sun, 7 Sep 2008 17:14:51 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Subject: Re: [Xen-devel] [PATCH 7 of 7] x86: always explicitly map acpi memory
Cc: "Ingo Molnar" <mingo@elte.hu>, "Xen Devel" <xen-devel@lists.xensource.com>,
       "Andi Kleen" <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <48C46B83.70704@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <patchbomb.1220826072@localhost>
	 <6f23bad119ae2ed00f1c.1220826079@localhost>
	 <86802c440809071635l1457659bufeefa6e65cc34bdf@mail.gmail.com>
	 <48C46B83.70704@goop.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 7, 2008 at 5:02 PM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> Yinghai Lu wrote:
>> actually,
>> case 1: acpi tables near mmio, range, we don't map them from
>> 2.6.27-rc1, and it is bigger than max_low_mapped...
>> case 2: some strange system put acpi in the middle of RAM... like when
>> 8G ram installed, but MMIO is 3.5G, BIOS put acpi tables around 2G..
>>
>
> OK, so what's your conclusion?  Is this change OK or not?
>

Acked-by: Yinghai Lu <yhlu.kernel@gmail.com>
