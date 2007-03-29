Return-Path: <linux-kernel-owner+w=401wt.eu-S932282AbXC2PnT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932282AbXC2PnT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2007 11:43:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932411AbXC2PnT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 29 Mar 2007 11:43:19 -0400
Received: from smtp121.iad.emailsrvr.com ([207.97.245.121]:55665 "EHLO
	smtp121.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282AbXC2PnS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2007 11:43:18 -0400
Message-ID: <460BDE95.90204@gentoo.org>
Date: Thu, 29 Mar 2007 11:43:17 -0400
From: Daniel Drake <dsd@gentoo.org>
User-Agent: Thunderbird 2.0b2 (X11/20070208)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>
CC: bugme-daemon@bugzilla.kernel.org,
       linux list <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [Bug 8255] Frequency Scaling not working properly using powernow-k7
References: <200703291304.l2TD4Dd6016401@fire-2.osdl.org>
In-Reply-To: <200703291304.l2TD4Dd6016401@fire-2.osdl.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave,

bugme-daemon@bugzilla.kernel.org wrote:
> http://bugzilla.kernel.org/show_bug.cgi?id=8255

> Okay. I tracked down the problem with git. Here is what is the submission that
> causes the problem:
> 
> solaris linux-git # git bisect good
> 0916bd3ebb7cefdd0f432e8491abe24f4b5a101e is first bad commit
> commit 0916bd3ebb7cefdd0f432e8491abe24f4b5a101e
> Author: Dave Jones <davej@redhat.com>
> Date:   Wed Nov 22 20:42:01 2006 -0500
> 
>         [PATCH] Correct bound checking from the value returned from _PPC method.

The above commit seems to be the culprit behind this 2.6.19 regression, 
which is still present as of 2.6.21-rc3 (so it's not the earlier issue 
found by Ingo). Any ideas?

Thanks,
Daniel

