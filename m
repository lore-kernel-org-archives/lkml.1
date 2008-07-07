Return-Path: <linux-kernel-owner+w=401wt.eu-S1755231AbYGGMMT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755231AbYGGMMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jul 2008 08:12:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753102AbYGGMMD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Jul 2008 08:12:03 -0400
Received: from nf-out-0910.google.com ([64.233.182.190]:47713 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753066AbYGGMMC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jul 2008 08:12:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=Hh+N7TAP2vr3c0Kc78M5j9cRvSvslP2xLAGf4SIodkMZKCwbJDpOooLogrsxQo3Gtp
         l4GyLNamvRB39bicQkGroncpiBpnDy/Tu3d1Abhcq/IPUgOSgiufrrvqPXTPN6KSq2vm
         UCJr0GL04tPLRHwcStWSbTWP1c5qjPa8iKiMA=
Message-ID: <fb82a8210807070512o3a5f8814kba83df94b7c7e04a@mail.gmail.com>
Date: Mon, 7 Jul 2008 08:12:00 -0400
From: "Jinkai Gao" <mickeygjk@gmail.com>
To: "Arjan van de Ven" <arjan@infradead.org>
Subject: Re: Suggestion: LKM should be able to add system call for itself
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <20080707000128.1e93d8e4@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <fb82a8210807062209t6cfe3e46m50a11b577f0540e7@mail.gmail.com>
	 <20080707000128.1e93d8e4@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 7, 2008 at 3:01 AM, Arjan van de Ven <arjan@infradead.org> wrote:
> On Mon, 7 Jul 2008 01:09:30 -0400
> "Jinkai Gao" <mickeygjk@gmail.com> wrote:
>
>> Above is to demonstrate that LKM is extension to kernel, and the
>> system calls should be able to extend as long as the kernel is
>> extending. So The LKM should be able to define its own user interface
>> by adding new system call for itself.
>
> Since we promise a stable ABI to userspace, this is a bit of a problem.
>
> But... look today, we already have various system calls implemented by
> modules. (example: sys_nfsservctl)
> but to make it fully dynamic? Not a good idea... nobody would be able
> to program to it.

Why? Using the interface we provide to add and delete system call (the
module can only unregister the system calls registered by itself), all
the existing system calls will be the same. It is just you can have
more system calls then you need, That shouldn't be a problem.
