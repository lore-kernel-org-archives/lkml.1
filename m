Return-Path: <linux-kernel-owner+w=401wt.eu-S1751570AbXC0Mnz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751570AbXC0Mnz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2007 08:43:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753831AbXC0Mnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 27 Mar 2007 08:43:55 -0400
Received: from nz-out-0506.google.com ([64.233.162.227]:29196 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbXC0Mny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2007 08:43:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=NQKS7UN04OZW8evg9JKORqj+JhbmzPU+LOr+I3lcD//keerYUZ0WA/X+4rLwRe7irXRH+NeudQmMyrKPbQeD9Gv0ayGVXSSEzikWkaFRpZ3WXC/0Vmf96nZSZrE0N9dF7pjbwe9laQ3J5HWzfpPIP5XmNsQyvyaTYKYmxr0Kzhg=
Message-ID: <d120d5000703270543ic410d8qd5865a83d6cdba8e@mail.gmail.com>
Date: Tue, 27 Mar 2007 08:43:52 -0400
From: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: Linux 2.6.21-rc5
Cc: "Linus Torvalds" <torvalds@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Andi Kleen" <ak@suse.de>, "Jaroslav Kysela" <perex@suse.cz>,
       "Takashi Iwai" <tiwai@suse.de>, "Ben Dooks" <ben-linux@fluff.org>,
       "Greg KH" <greg@kroah.com>
In-Reply-To: <20070326221731.f4792260.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <Pine.LNX.4.64.0703251559560.6730@woody.linux-foundation.org>
	 <20070326221731.f4792260.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/27/07, Andrew Morton <akpm@linux-foundation.org> wrote:
>
> I have a few fixes here which belong to subsystem trees, which were missed
> by the maintainers and which we probably want to get into 2.6.21.
>
> ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.21-rc5/2.6.21-rc5-mm2/broken-out/fix-sudden-warps-in-mousedev.patch
>

Slightly different fix is already in input tree. I'd perfer waiting
for 2.6.22 as this only affects touchpads when not using synaptics X
driver (which most distributions use by default).

-- 
Dmitry
