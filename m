Return-Path: <linux-kernel-owner+w=401wt.eu-S1755484AbYINSNe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755484AbYINSNe (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Sep 2008 14:13:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753986AbYINSNZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 14 Sep 2008 14:13:25 -0400
Received: from rv-out-0506.google.com ([209.85.198.239]:18643 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753971AbYINSNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Sep 2008 14:13:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=BwTCaNq5jnovDxBBdM6XkbnHoySLvFFIBmrL10gUSx7H3lREzIM7pGLfUumCZNUsKL
         weiXjmCE7bkfrwwjiOO++nk9zInQN672aZ4ddBpToCa4nzHL1TLKM2ALqU9XB+kI8g9d
         PRzocpB7EpEZ0gfj+/d/AOZFlCJjeGRk3HGxQ=
Message-ID: <86802c440809141113r62199a6as44cacecb960ebaf7@mail.gmail.com>
Date: Sun, 14 Sep 2008 11:13:24 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH] apci: dump slit
Cc: "Pavel Machek" <pavel@suse.cz>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andi Kleen" <andi@firstfloor.org>,
       "Andrew Morton" <akpm@linux-foundation.org>, hpa@zytor.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080914160403.GA20082@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1221243468-8016-1-git-send-email-yhlu.kernel@gmail.com>
	 <20080912122031.eca8723e.akpm@linux-foundation.org>
	 <86802c440809121229i14727af4nd1416044b06ebb94@mail.gmail.com>
	 <878wtxrrwh.fsf@basil.nowhere.org>
	 <alpine.LFD.1.10.0809122313440.13819@apollo.tec.linutronix.de>
	 <20080914112222.GA3956@ucw.cz> <20080914122618.GD16097@elte.hu>
	 <20080914155928.GB4845@ucw.cz> <20080914160403.GA20082@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 14, 2008 at 9:04 AM, Ingo Molnar <mingo@elte.hu> wrote:
>>
>> Dumping when user requested it on commandline seems like good
>> compromise to me.
>
> great! Yinghai, mind reworking the patch in that direction please? I'd
> suggest to enable the optional dumping of all things BIOS environment
> related, not just the ACPI/SLIT.
>
> there's also CONFIG_X86_VERBOSE_BOOTUP=y [default disabled] - which
> could be coupled with an x86=verbose boot parameter or so.

will work on it.

YH
