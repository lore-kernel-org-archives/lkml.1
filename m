Return-Path: <linux-kernel-owner+w=401wt.eu-S1761090AbYGRBPf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761090AbYGRBPf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jul 2008 21:15:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755095AbYGRBPY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 17 Jul 2008 21:15:24 -0400
Received: from wf-out-1314.google.com ([209.85.200.173]:5730 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754661AbYGRBPW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jul 2008 21:15:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=OBaaEOl38Xyd7wpnApM0wFWHbNDEmACWamsuYWT1bEwI7uLvLjF8gKq0SNMpFaVguR
         pKuEnnoBrLp3sCGqiINA2SQDe+6PX1kbw5NKUPT92Gra+7vCcBVgtdbyw/WjCJkpHUtR
         QJKeaEO4JKkcNS6Y5pcEjtsEvMrzhUNoG0R6c=
Message-ID: <8bd0f97a0807171815x69185d2bnca3b410caf0a8afe@mail.gmail.com>
Date: Thu, 17 Jul 2008 21:15:21 -0400
From: "Mike Frysinger" <vapier.adi@gmail.com>
To: "Denys Vlasenko" <vda.linux@googlemail.com>
Subject: Re: [PATCH] (updated, rolled up) make section names compatible with -ffunction-sections -fdata-sections
Cc: "Andrew Morton" <akpm@linux-foundation.org>, mingo@elte.hu, x86@kernel.org,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Russell King" <rmk@arm.linux.org.uk>,
       "David Howells" <dhowells@redhat.com>,
       "Ralf Baechle" <ralf@linux-mips.org>,
       "Lennert Buytenhek" <kernel@wantstofly.org>,
       "Josh Boyer" <jwboyer@linux.vnet.ibm.com>,
       "Paul Mackerras" <paulus@samba.org>,
       "David Woodhouse" <dwmw2@infradead.org>,
       "Andi Kleen" <andi@firstfloor.org>, torvalds@linux-foundation.org,
       "Paul Gortmaker" <paul.gortmaker@windriver.com>,
       linux-embedded@vger.kernel.org, linux-kernel@vger.kernel.org,
       "Tim Bird" <tim.bird@am.sony.com>,
       "Martin Schwidefsky" <schwidefsky@de.ibm.com>,
       "Dave Miller" <davem@davemloft.net>,
       "Linux Arch Maintainers" <linux-arch@vger.kernel.org>,
       "Bryan Wu" <cooloney@kernel.org>
In-Reply-To: <200807172213.37411.vda.linux@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200807172213.37411.vda.linux@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2008 at 4:13 PM, Denys Vlasenko
<vda.linux@googlemail.com> wrote:
> Hi Andrew,
>
> Here is the update against current Linus tree,
> rolled up into one patch.
>
> James Bottomley suggested a different naming scheme:
> instead of swapping parts (.text.head -> .head.text),
> prepend .kernel to our special section names.
> This patch implements his idea.
>
> ppc and v850 are dropped per comments from arch people.
> parisc and x86 had minor fixes. x86 fix added proper
> executable bits to a section:
>
> -.section ".text.head"
> +.section ".kernel.text.head","ax",@progbits
>
> Does arch/m68k/kernel/sun3-head.S need the same fix?
>
> The patch is run-tested on x86_64.
>
> I would like to ask arch maintainers to ACK/NAK this patch,
> and Andrew to act accordingly.

the Blackfin piece is just one line and shouldnt be a problem from our
side.  thanks.

btw, arch maintainers have an alias "linux-arch@vger.kernel.org" ...
but it doesnt appear to be in MAINTAINERS ?
-mike
