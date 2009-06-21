Return-Path: <linux-kernel-owner+w=401wt.eu-S1754728AbZFUL0X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754728AbZFUL0X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Jun 2009 07:26:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751267AbZFUL0P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 21 Jun 2009 07:26:15 -0400
Received: from mail-fx0-f224.google.com ([209.85.220.224]:50065 "EHLO
	mail-fx0-f224.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751261AbZFUL0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Jun 2009 07:26:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=TIa5Iacdxes4AMufGSzONqMp+TKwq3bI6jqLAzKIlfhcUwpOChUzH8gfIDVv45/+a2
         8XyeHqk5L1zmr+kxT1nmM6S9BVHfnUL58aCYTXA1RTWEihLJMpHFnnpE88W1hDcpZnBL
         ol7pPEjPCFcoNrNsGeXVn6Q0CtwRFFSRtgW24=
MIME-Version: 1.0
In-Reply-To: <200906211152.25100.arvidjaar@mail.ru>
References: <200906211152.25100.arvidjaar@mail.ru>
Date: Sun, 21 Jun 2009 14:26:15 +0300
X-Google-Sender-Auth: 37f5e1e30ae19975
Message-ID: <84144f020906210426h6a41ad3csf6d9731663e30834@mail.gmail.com>
Subject: Re: Why half of slabs are not shown in /proc/slabinfo?
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Andrey Borzenkov <arvidjaar@mail.ru>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 21, 2009 at 10:52 AM, Andrey Borzenkov<arvidjaar@mail.ru> wrote:
> Mandriva kernel 2.6.30 using SLUB:
>
> {pts/1}% grep SLUB /boot/config
> CONFIG_SLUB_DEBUG=y
> CONFIG_SLUB=y
> # CONFIG_SLUB_DEBUG_ON is not set
> # CONFIG_SLUB_STATS is not set
>
> Some of slabs (e.g. filp) are not shown in /proc/slabinfo; comparing
> number of entries under /sys and slabinfo results in
>
> {pts/0}% =ls -1 /sys/kernel/slab | grep -v : | wc -l
> 131
> {pts/0}% wc -l /proc/slabinfo
> 68 /proc/slabinfo
> {pts/0}%
>
> so almost half of the all entries are missing. Is it expected or there
> is something wrong here?

Can you post the actual file listing of /sys/kernel/slab and the
contents of /proc/slabinfo?

                               Pekka
