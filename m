Return-Path: <linux-kernel-owner+w=401wt.eu-S932380AbZKXI7x@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932380AbZKXI7x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 03:59:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932311AbZKXI7x
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 03:59:53 -0500
Received: from mail-bw0-f223.google.com ([209.85.218.223]:49438 "EHLO
	mail-bw0-f223.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932317AbZKXI7w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 03:59:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=q3ne9V9+roFn6ZUEM9d6nrtPwapq4yTvgGPHHv3HwOPvbWciYkVKdyIQ2c77IKLPX2
         YMhCITcidIWp74xgGFRu7WpVLichKeoiL4gAdZxrf1egouL82u8Z5D7hNjtTaKyKTo/B
         XKo8OeEgVg7fupS9BRozvpQIepcYfLXLEwtIY=
MIME-Version: 1.0
In-Reply-To: <806dafc20911240054p74bd4d67h97430a02ba86b468@mail.gmail.com>
References: <806dafc20911240054p74bd4d67h97430a02ba86b468@mail.gmail.com>
Date: Tue, 24 Nov 2009 03:59:57 -0500
Message-ID: <806dafc20911240059r49b2b3b8o703b8d054cc913f4@mail.gmail.com>
Subject: Re: PATCH: fix multiple eMagic 6|2m regressions introduced in 2.6.27
From: Monty Montgomery <xiphmont@gmail.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@osdl.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I should mention that when I first started strated working on this
problem tonight, I saw Clemens Ladisch's patch from a few days ago.
His reported bug and patch is identical to my 'bug 1' and the first
change in my patch.  Unfortunately, this fix only prevented the oops,
it was not enough to make the eMagic actually function.  The other two
bugfixes were absolutely necessary as well.

I included the fix in my patch as well as I was uncertain if it had
yet been applied to the kernel tree, and it is important not to miss
it.

Monty
