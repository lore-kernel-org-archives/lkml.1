Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0CHRPF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 12:15:05 -0500
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43477 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab0CHRO7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 12:14:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=i4Cy18TDvtG0Yw44jJEXb29HiJprfswzXkd/REWP/S2qEBdoOuLZzl273i/GeV1Z7d
         e+X3hytM0nIpgyigfpaqnqR2H+qjHlV0tjatepSSvXX794Sma0Grt1PVlEgxxR1vK/c7
         ym2HYdGCbsmkVxrFBmempCBji0rHDe9TMR0Yo=
MIME-Version: 1.0
In-Reply-To: <2d460de71003010934m76594f4fk2e0b505b1867538c@mail.gmail.com>
References: <2d460de71002260242o50952e51sa9aee59d2b7bbe2e@mail.gmail.com>
	 <4807377b1002261152x6a92cfffl6ecb09d0574156d4@mail.gmail.com>
	 <2d460de71003010934m76594f4fk2e0b505b1867538c@mail.gmail.com>
Date: Mon, 8 Mar 2010 18:14:57 +0100
Message-ID: <2d460de71003080914l723b9f9by10b7f503cfb7a0a2@mail.gmail.com>
Subject: Re: New thread: page allocation failure with E1000 (seems to be 
	reproducible)
From: Richard Hartmann <richih.mailinglist@gmail.com>
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Cc: e1000-devel@lists.sf.net, linux-kernel@vger.kernel.org,
       Andrew Pochinsky <avp@mit.edu>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 1, 2010 at 18:34, Richard Hartmann
<richih.mailinglist@gmail.com> wrote:

>> You might be able to try the sysctl tweak to reserve a little more
>> memory for driver allocations.
>> # sysctl vm.min_free_kbytes
>> # sysctl -e vm.min_free_kbytes=<double what you have>
>
> I will try that, thanks.

It was

host:~# sysctl vm.min_free_kbytes
vm.min_free_kbytes = 16174
host:~#

btw.


Richard
