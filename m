Return-Path: <linux-kernel-owner+w=401wt.eu-S1756148AbYDULDd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148AbYDULDd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2008 07:03:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754681AbYDULDY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 21 Apr 2008 07:03:24 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:9516 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538AbYDULDX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2008 07:03:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=wZVzYB5HBTVc41Jn/QDmz4Sf8R3RqEQ+tUA2L5Z9pLDIfHXQSF1fkO+J21FbawuIV1hkY6yYiFHVgervBMK7T+kzH4pGEu2yC2QB6zp6FOiouiO7kIvFyrYb52mBm6XiarbrRR5GkJZAhDUaztLqCP6uQ3bY7JZS4wI6FP2FvII=
Message-ID: <b647ffbd0804210403g1fe02f2pb653eafd704ad624@mail.gmail.com>
Date: Mon, 21 Apr 2008 13:03:20 +0200
From: "Dmitry Adamushko" <dmitry.adamushko@gmail.com>
To: "Dan Upton" <upton.dan.linux@gmail.com>
Subject: Re: migration thread and active_load_balance
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <ba7d8f720804201744m10cfa1b7n1a37b9d7c52b3622@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <ba7d8f720804201121h6c024dcrabd301c8b4be7a4@mail.gmail.com>
	 <b647ffbd0804201426r3bb55daw2899f6045b78fa51@mail.gmail.com>
	 <ba7d8f720804201744m10cfa1b7n1a37b9d7c52b3622@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 21/04/2008, Dan Upton <upton.dan.linux@gmail.com> wrote:
> [ ... ]
>
>  kernel BUG at kernel/sched.c:2103

and what's this line in your patched sched.c?

is it -- BUG_ON(!irqs_disabled());  ?

anything in your unposted code (e.g. find_coolest_cpu()) that might
re-enable the interrupts before __migration_task() is called?

If you post your modifications as a patch
(Documentation/applying-patches.txt) that contains _all_ relevant
modifications, it'd be easier to guess what's wrong.


>
>  -dan
>

-- 
Best regards,
Dmitry Adamushko
