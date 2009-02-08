Return-Path: <linux-kernel-owner+w=401wt.eu-S1753506AbZBHKZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753506AbZBHKZ0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Feb 2009 05:25:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbZBHKZQ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Feb 2009 05:25:16 -0500
Received: from fg-out-1718.google.com ([72.14.220.153]:3517 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752324AbZBHKZO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Feb 2009 05:25:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qph55Wrtd+2Wqqwb4WLIdGQiXB2LbVVBiyEiLYny1j8mMwZkBXWFR9WjG7a/vIgx1/
         BL1SdGQkF78ODP0EDgYgkVWuhZLPZ2x1tzO+FNVk7rxuhKUormLvnwbiCnsDQIeVf5iG
         0lnRrXS3oaOzuVqb0nm+NBwgACB0jEQfCp1OM=
MIME-Version: 1.0
In-Reply-To: <c43b2e150902080209s2444718fjb08086eed1a835cc@mail.gmail.com>
References: <c43b2e150902071144j4f01e754y83205ad8d734fd95@mail.gmail.com>
	 <20090207200652.GA3255@x200.localdomain>
	 <c43b2e150902071217id7bfdbaq66dbbd7d5e370c23@mail.gmail.com>
	 <20090207205606.GA3490@x200.localdomain>
	 <20090207164057.777f482f@infradead.org>
	 <c43b2e150902080209s2444718fjb08086eed1a835cc@mail.gmail.com>
Date: Sun, 8 Feb 2009 11:25:13 +0100
Message-ID: <c43b2e150902080225kefc3f0bk89aa270397bcc33f@mail.gmail.com>
Subject: Re: viafb triggers BUG at mm/vmalloc.c:294 [kernel 2.6.28.3]
From: wixor <wixorpeek@gmail.com>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Arjan van de Ven <arjan@infradead.org>, JosephChan@via.com.tw,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, it didn't help really. Even with vmalloc=300M after a couple
modprobe/rmmods i got the same BUG. And I didn't manage to get
anything on display. Moreover, rmmod doesn't bring back the vga
console.

--
wixor
