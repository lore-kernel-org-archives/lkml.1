Return-Path: <linux-kernel-owner+w=401wt.eu-S1762339AbXK2KH3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762339AbXK2KH3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2007 05:07:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758891AbXK2KHR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Nov 2007 05:07:17 -0500
Received: from ug-out-1314.google.com ([66.249.92.174]:24467 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757696AbXK2KHP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2007 05:07:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=iDqaOKQbKwlCe3AiV80aBLGe6Itnrz06mBNsN1N/IdHFOlLS7/+T8cdCMM2bok3mbDEVKt45LJ0Kf3yJSq2oRG4OpeaeidYOMpcziXrlc6eLa4TzXSIbgt5Tryre+ydAdHHYw0r3rhIAj/Dh/9JndqcxEdF2jsYrmgBrOH//n9o=
Message-ID: <b6fcc0a0711290207jf82e618uccecf922a22c4f33@mail.gmail.com>
Date: Thu, 29 Nov 2007 13:07:14 +0300
From: "Alexey Dobriyan" <adobriyan@gmail.com>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Subject: Re: does /proc/sys/kernel/modprobe actually do anything?
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <alpine.LFD.0.9999.0711290438060.13461@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.0.9999.0711290438060.13461@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/29/07, Robert P. J. Day <rpjday@crashcourse.ca> wrote:
> echo '#! /bin/sh' > /tmp/modprobe
> echo 'echo "$@" >> /tmp/modprobe.log' >> /tmp/modprobe
> echo 'exec /sbin/modprobe "$@"' >> /tmp/modprobe
> chmod a+x /tmp/modprobe
> echo /tmp/modprobe > /proc/sys/kernel/modprobe
>
>   i've tried that and i don't see that it does anything whatsoever.  i
> ran modprobe under "strace" and it doesn't appear to make any effort
> to check /proc/sys/kernel/modprobe.

Kernel, not modprobe, checks /proc/sys/kernel/modprobe .
