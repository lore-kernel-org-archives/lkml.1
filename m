Return-Path: <linux-kernel-owner+w=401wt.eu-S1757054AbYBYFj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757054AbYBYFj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2008 00:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752176AbYBYFjT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 Feb 2008 00:39:19 -0500
Received: from rv-out-0910.google.com ([209.85.198.186]:32854 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118AbYBYFjS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2008 00:39:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fUr0azNZ9z3tEXu718eg3GUsD6hHfrbJD/TmAqOeT+eOd1QlW7ZCllvriWIKX41iYLILU6pe7vrFMkyAdIob4FDzmrsJzNrOCsqnxPfKF9UBm0hEkkmOIOBiPsOL9aaWPf/yPR6obQa5Gr36Liu9xjZVJHwvacbsImRvtHtZ+Sw=
Message-ID: <86802c440802242139j1a464f4dx32bd3815733d0cb4@mail.gmail.com>
Date: Sun, 24 Feb 2008 21:39:14 -0800
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCH] x86_64: make amd quad core 8 socket system not be clustered_box v2
Cc: "Ingo Molnar" <mingo@elte.hu>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       kiran@scalemp.com, shai@scalemp.com
In-Reply-To: <20080224122903.GC13637@one.firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200802210258.45011.yinghai.lu@sun.com>
	 <200802221102.31019.yinghai.lu@sun.com>
	 <47BF1BD9.4020808@firstfloor.org>
	 <200802232148.43255.yinghai.lu@sun.com>
	 <20080224122903.GC13637@one.firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 24, 2008 at 4:29 AM, Andi Kleen <andi@firstfloor.org> wrote:
> On Sat, Feb 23, 2008 at 09:48:42PM -0800, Yinghai Lu wrote:
>  >
>  > quad core 8 socket system will have apic id lifting.the apic id range could
>  > be [4, 0x23]. and apic_is_clustered_box will think that need to three clusters
>  > and that is large than 2. So it is treated as clustered_box.
>
>  Ok I see you chose the quick hack over doing it properly ...

you didn't answer my question:

for IBM Summit2, Unisys ES7000, and ScaleMP vSMP,
if call cpus sockets are fully populated with quadcore cpus, do they
still have hole between apic id?

YH
