Return-Path: <linux-kernel-owner+w=401wt.eu-S932645AbXG0DZ0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932645AbXG0DZ0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2007 23:25:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759073AbXG0DZR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jul 2007 23:25:17 -0400
Received: from wa-out-1112.google.com ([209.85.146.177]:13029 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755630AbXG0DZQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2007 23:25:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references:x-google-sender-auth;
        b=LLUuC8QkuBxvWPK82b30NpL/mMoUlbMpYBHBU+DaHTYclduQLrUeyZ+fFAwfLknU9ksb/3az18I+f+dM1h50v3Iq7J9q/XsXabOwuXvU3DF1aJuDMSIkhFE61wgrTsR0RtNvbT0zHygD854dCgyzF0Vdn2u1J5LZ8+mPg247h5k=
Message-ID: <31e679430707262025g5aa7c812s7522d2ff7fd2994c@mail.gmail.com>
Date: Thu, 26 Jul 2007 23:25:15 -0400
From: "Felipe Balbi" <felipebalbi@users.sourceforge.net>
To: "Tiago Vignatti" <vignatti@c3sl.ufpr.br>
Subject: Re: [PATCH] exporting address to the page fault notifier
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <46A95CFC.9050509@c3sl.ufpr.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
References: <46A95CFC.9050509@c3sl.ufpr.br>
X-Google-Sender-Auth: e66523946ecb744a
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/26/07, Tiago Vignatti <vignatti@c3sl.ufpr.br> wrote:
> I made a module using the notifier scheme which already exists inside
> the kernel. The problem is that the page fault notifier doesn't show the
> address which happened the fault.
>
> This little patch increments this functionality. I chose to break the
> ABI putting a new field in 'die_args' instead build a new struct only
> for it. The patch and the module notifier comes attached.

don't send attachments... send the patch inline at the mail body this
allows easier commenting on the code.

read Documentation/SubmittingPatches about how to send patches to lkml.

>
> my regards
>
>
> --
> Tiago Vignatti
> C3SL - Centro de Computação Científica e Software Livre
> www.c3sl.ufpr.br
>
>


-- 
Best Regards,

Felipe Balbi
felipebalbi@users.sourceforge.net
