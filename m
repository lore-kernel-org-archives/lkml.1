Return-Path: <linux-kernel-owner+w=401wt.eu-S1753148AbYHSGxa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753148AbYHSGxa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2008 02:53:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750851AbYHSGxV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Aug 2008 02:53:21 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:35365 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750789AbYHSGxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2008 02:53:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=kujb5B+aNwe7ROJbuxnqN1/iRe5Zk4S8wYwOc4WFb20D3mb6v9ZTcd91BeIaiRyc+d
         LWYygJdak8V21miutmz1l2Vv1Skjc+I24LLTr2L4uKYNRJFcuOdm4Oqud/UTESChACJd
         iQeRjh+OGEpEd2RaJK+tOMmJLHc7JkDJDeTw0=
Message-ID: <19f34abd0808182353n2174760ao135732327130a727@mail.gmail.com>
Date: Tue, 19 Aug 2008 08:53:19 +0200
From: "Vegard Nossum" <vegard.nossum@gmail.com>
To: "Alan Cox" <alan@lxorguk.ukuu.org.uk>
Subject: Re: 2.6.25.11-97.fc9 (P): idr_remove called for id=236 which is not allocated
Cc: LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080818231546.73020e41@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <19f34abd0808150811w2b77479fnead3ae6b527ad4dc@mail.gmail.com>
	 <19f34abd0808150827m5128c8f6wd517796d95227654@mail.gmail.com>
	 <20080815162848.08ff793c@lxorguk.ukuu.org.uk>
	 <19f34abd0808151426i69256b59m25a9a0676b50a6ba@mail.gmail.com>
	 <20080818231546.73020e41@lxorguk.ukuu.org.uk>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2008 at 12:15 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
> pty: If the administrator creates a device not for a ptmx slave don't error
>
> From: Alan Cox <alan@redhat.com>
>
>
> The open path for ptmx slaves is via the ptmx device. Opening them any
> other way is not allowed. Vegard Nossum found that previously this was not
> the case and mknod foo c 128 42; cat foo would produce nasty diagnostics
> ---

Thanks, this seems to work for me. I do get a "SLAP" in dmesg each
time, however :-)


Vegard

-- 
"The animistic metaphor of the bug that maliciously sneaked in while
the programmer was not looking is intellectually dishonest as it
disguises that the error is the programmer's own creation."
	-- E. W. Dijkstra, EWD1036
