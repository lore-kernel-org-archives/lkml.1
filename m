Return-Path: <linux-kernel-owner+w=401wt.eu-S1754812AbYBSSTR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754812AbYBSSTR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2008 13:19:17 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751929AbYBSSTA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 19 Feb 2008 13:19:00 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:59067 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYBSSTA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2008 13:19:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=mDGEn5McUWMhHcTBq5/gd0tdVrxRp9iHQaLdrAAklIzNPGFmm81ALIw2l6AdVVplVYDTA8kaevCP1nZdcq+E2u+AN/OPFwBGGdbEQsIsBueJ5/sR1ugGwm8VhRiUYfbe/GlN5RASDl3XrT8y2dm+KgEG1XqI4+YmwXgdWeGh37E=
Message-ID: <6101e8c40802191018t668faf3avba9beeff34f7f853@mail.gmail.com>
Date: Tue, 19 Feb 2008 19:18:58 +0100
From: "Oliver Pinter" <oliver.pntr@gmail.com>
To: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: SMP-related kernel memory leak
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <e2e108260802190300k5b0f60f6tbb4f54997caf4c4e@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <e2e108260802190300k5b0f60f6tbb4f54997caf4c4e@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Helló!

this patch fixed them http://lkml.org/lkml/2008/2/18/405 ?

On 2/19/08, Bart Van Assche <bart.vanassche@gmail.com> wrote:
> Hello,
>
> I noticed that the amount of memory used by the Linux kernel steadily
> increases over time on SMP systems (x86 architecture, 32-bit kernel).
> This problem disappears when I add maxcpus=1 to the kernel command
> line. I have observed this behavior both on the 2.6.22.18 and 2.6.24.2
> kernels. Did anyone notice anything similar ?
>
> See also: http://bugzilla.kernel.org/show_bug.cgi?id=9991
>
> Bart Van Assche.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>


-- 
Thanks,
Oliver
