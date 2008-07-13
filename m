Return-Path: <linux-kernel-owner+w=401wt.eu-S1755893AbYGMTAQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755893AbYGMTAQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2008 15:00:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754043AbYGMTAE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 Jul 2008 15:00:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.236]:7455 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753986AbYGMTAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2008 15:00:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=fNui8kWsyEg0TcecFMNGF1CaRbjTIMku9Djw3k6om6F8JK3moCLNp7a1vhCKuW6OGe
         TaXPlAH6UYM8O19jiMHmZmDyuG/Ub7/z82aA9JbuQH0Q+5j6W3U85XFLwo0DspHlc5rg
         xlY5NWj1dDvBwsqGXQ6DAm35OqFRagfWf+j3k=
Message-ID: <86802c440807131200o34568304mb1bbd84baea4faa6@mail.gmail.com>
Date: Sun, 13 Jul 2008 12:00:02 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Andi Kleen" <andi@firstfloor.org>
Subject: Re: [PATCh] x86: overmapped fix when 4K pages on tail - 64bit
Cc: "Arjan van de Ven" <arjan@infradead.org>, "Ingo Molnar" <mingo@elte.hu>,
       "Thomas Gleixner" <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>,
       "Suresh Siddha" <suresh.b.siddha@intel.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <487A4DFC.5090701@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807080141.05436.yhlu.kernel@gmail.com>
	 <200807080143.27997.yhlu.kernel@gmail.com>
	 <200807092015.03004.yhlu.kernel@gmail.com>
	 <20080710071640.5035cd70@infradead.org>
	 <874p6t25n5.fsf@basil.nowhere.org>
	 <86802c440807131117g3ba9e61chea61af81b7537bb0@mail.gmail.com>
	 <487A4DFC.5090701@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 13, 2008 at 11:48 AM, Andi Kleen <andi@firstfloor.org> wrote:
>
>> with this patch, my 256g system still use gbpages for 1g-3g, 4g-256g
>
> 256GB certainly qualifies as "large system". But as Linus always says:
> Linux is not for servers only. Ignoring the small systems makes you
> look bad.

You want system with 2g use gbpage too?
that is because of acpi nvs or smm code sit near the RAM.... why we
need to direct map these area?

YH
