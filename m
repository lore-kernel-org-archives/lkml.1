Return-Path: <linux-kernel-owner+w=401wt.eu-S1767040AbXEBVgu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767040AbXEBVgu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2007 17:36:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1767043AbXEBVgu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 May 2007 17:36:50 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53223 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1767040AbXEBVgt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2007 17:36:49 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jeremy Fitzhardinge <jeremy@goop.org>, Gerd Hoffmann <kraxel@redhat.com>,
       Jeff Garzik <jeff@garzik.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@in.ibm.com>,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
References: <20070428758.455116000@suse.de>
	<20070428175909.1D09D151CA@wotan.suse.de> <46338D72.70402@garzik.org>
	<m1fy6kdzi1.fsf@ebiederm.dsl.xmission.com> <4634483E.9030307@goop.org>
	<m14pmz8bbb.fsf@ebiederm.dsl.xmission.com> <46363A68.6080201@goop.org>
	<46385A8A.6070405@redhat.com> <4638AB55.20408@goop.org>
	<4638F9BE.8090508@zytor.com>
	<m13b2fvsbn.fsf@ebiederm.dsl.xmission.com> <46390185.30900@zytor.com>
Date: Wed, 02 May 2007 15:36:17 -0600
In-Reply-To: <46390185.30900@zytor.com> (H. Peter Anvin's message of "Wed, 02
	May 2007 14:24:21 -0700")
Message-ID: <m1y7k6vrfy.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> Eric W. Biederman wrote:
>> 
>> So we won't do this casually and if it there are real problems we will
>> remove the ELF magic number.
>> 
>
> I think we can use ELF-compatible format just fine, but it would make
> more sense to use a non-ELF magic number from the start, instead of
> signalling it with a note.  Since bootloaders need to be aware, anyway,
> they can just detect this magic and treat is as an Linux calling
> convention ELF image, or they can not detect it, and treat it as a
> bzImage.  As a side benefit, we:
>
> a) can use a magic number that contains a jump instruction (to keep the
> non-bootsector happy);
> b) get a proper Linux kernel magic number.

To the best of my knowledge I have already resolved both of those concerns,
in my current code.

Eric
