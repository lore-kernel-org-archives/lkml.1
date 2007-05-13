Return-Path: <linux-kernel-owner+w=401wt.eu-S1758505AbXEMG3b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758505AbXEMG3b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 May 2007 02:29:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756978AbXEMG3Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 13 May 2007 02:29:25 -0400
Received: from nz-out-0506.google.com ([64.233.162.226]:41068 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109AbXEMG3Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 May 2007 02:29:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=ZOC8ePOSE3crDitU4gnHIhltt8iZberDKHxoqpEEifNxpdcAlJY0YC9EqyeSpnoqyRnQKp6Y87up31NROa1FDYaCJ1JOSFzAandWwvWiOU7ghA8qmOGX8UVCAMeJPpyxYpGObjYoUIp48HNwb4co75EP/FxuZdRxPoQrJuCGqb4=
Message-ID: <86802c440705122329y27c6ef92v8cff43d52b99ae69@mail.gmail.com>
Date: Sat, 12 May 2007 23:29:23 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Subject: Re: [PATCH]x86_64: build and use GDT on copied compressed kernel
Cc: "Andi Kleen" <ak@suse.de>, "Andrew Morton" <akpm@linux-foundation.org>,
       "Vivek Goyal" <vgoyal@in.ibm.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <m1ejllqmo8.fsf@ebiederm.dsl.xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <86802c440705122233y327756e7te534199f46b2059d@mail.gmail.com>
	 <m1ejllqmo8.fsf@ebiederm.dsl.xmission.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/12/07, Eric W. Biederman <ebiederm@xmission.com> wrote:
> Overwriting the GDT should be fine because we don't reload the segments,
> after we overwrite it.  GDT entries are only read when we load segments.
> Interrupts are disabled so that should not cause a problem.
>
> Why do you think the current behaviour is a problem?

just think if GDT should not be overwriten when we are still under
that GDT setting.
didn't have chance to test that in HDT or other debug device, when
setting breaking point after that GDT is overwriten.

YH
