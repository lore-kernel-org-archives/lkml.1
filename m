Return-Path: <linux-kernel-owner+w=401wt.eu-S1762494AbXFJRiR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762494AbXFJRiR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2007 13:38:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753185AbXFJRiI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 10 Jun 2007 13:38:08 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:6966 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756837AbXFJRiG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2007 13:38:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NvtE8K0vA0IcrLUdsZ/+5UAfdVjQ/H3NiXzWorb/r3Z7o3j87fUUME8/UVt6r4jBitLqlP80Y2mBEXdy+XUtNm6wKbdQG7H/8iacjqOkH3fIjGK/o/nrr1MmQkDdru6Ol636ASe8LI+bXWl0RLlzn4ZLTaU16Dxwvto4ryli/Bg=
Message-ID: <5bdc1c8b0706101038q2f0e3418t1a595e749b5bfe71@mail.gmail.com>
Date: Sun, 10 Jun 2007 10:38:05 -0700
From: "Mark Knecht" <markknecht@gmail.com>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: 2.6.21-rt9 - IRQ23 consuming a steady 2.7% of CPU
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
       "Lee Revell" <rlrevell@gmail.com>
In-Reply-To: <20070610172452.GA7560@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <5bdc1c8b0706100946k3acd6374uac8248e78f97433d@mail.gmail.com>
	 <20070610172452.GA7560@elte.hu>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/10/07, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Mark Knecht <markknecht@gmail.com> wrote:
>
> > 23:    1739277   IO-APIC-fasteoi   ohci_hcd:usb2, eth0
>
> > 00:0a.0 Bridge: nVidia Corporation CK804 Ethernet Controller (rev a3)
>
> ok, that's forcedeth. Does that behavior go away if you revert the
> change below, via patch -p0 -R ?
>
> but in general, -rt will track IRQ cpu usage accurately, while mainline
> does not measure it at all when in idle. So a frequent IRQ on mainline
> might be using up similar amounts of of CPU time as well, but it's not
> reported.
>
>         Ingo
>

Ingo,
   GMail is being kranky. Can you please send the patch as a zipped attachment?

Thanks,
Mark
