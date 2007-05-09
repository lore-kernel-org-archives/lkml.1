Return-Path: <linux-kernel-owner+w=401wt.eu-S968943AbXEIE7a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968943AbXEIE7a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2007 00:59:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S967350AbXEIE7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 May 2007 00:59:19 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:36684 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934664AbXEIE7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2007 00:59:18 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: yhlu <yhlu.kernel@gmail.com>
Cc: vgoyal@in.ibm.com, "H. Peter Anvin" <hpa@zytor.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Gerd Hoffmann" <kraxel@redhat.com>, "Jeff Garzik" <jeff@garzik.org>,
       patches@x86-64.org, linux-kernel@vger.kernel.org,
       virtualization <virtualization@lists.linux-foundation.org>
Subject: Re: [patches] [PATCH] [21/22] x86_64: Extend bzImage protocol for relocatable bzImage
References: <4638FC39.4010101@goop.org> <46390523.5010809@goop.org>
	<463909AF.9040205@zytor.com> <20070503045031.GA5794@in.ibm.com>
	<m1tzuuv24z.fsf@ebiederm.dsl.xmission.com>
	<86802c440705080941y69ddd5d6lab170c5f3967f148@mail.gmail.com>
	<m1sla7i68s.fsf@ebiederm.dsl.xmission.com>
	<86802c440705081033s19365843i5b955ae175de73eb@mail.gmail.com>
	<86802c440705081151r6bfd82e4o50c6a34b2b2a833f@mail.gmail.com>
	<20070509033348.GA12361@in.ibm.com>
	<86802c440705082142u7ee2b402q9ae09edbed32766a@mail.gmail.com>
Date: Tue, 08 May 2007 22:58:27 -0600
In-Reply-To: <86802c440705082142u7ee2b402q9ae09edbed32766a@mail.gmail.com>
	(yhlu.kernel@gmail.com's message of "Tue, 8 May 2007 21:42:02 -0700")
Message-ID: <m1ejlqtwy4.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

yhlu <yhlu.kernel@gmail.com> writes:

> On 5/8/07, Vivek Goyal <vgoyal@in.ibm.com> wrote:
>> On Tue, May 08, 2007 at 11:51:35AM -0700, yhlu wrote:
>> This message generally appears if you did not specify --args-linux
>> on kexec command line while loading vmlinux.
>>
> besides elf-x86_64, still need --args-linux to pass sth? but how to
> let it load ramdisk?

Same arguments just use --args-linux.

Basically the calling convention needs to be specified because
there isn't a universal one, and /sbin/kexec can't yet detect
vmlinux is linux.

Eric
