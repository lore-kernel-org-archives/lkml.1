Return-Path: <linux-kernel-owner+w=401wt.eu-S1756005AbXKFQ4P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756005AbXKFQ4P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Nov 2007 11:56:15 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753459AbXKFQ4B
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Nov 2007 11:56:01 -0500
Received: from gw.goop.org ([64.81.55.164]:37269 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228AbXKFQ4A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Nov 2007 11:56:00 -0500
Message-ID: <47309C85.6030904@goop.org>
Date: Tue, 06 Nov 2007 08:55:33 -0800
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.5 (X11/20070727)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "Eric W. Biederman" <ebiederm@xmission.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Mikael Petterson <mikpe@it.uu.se>
Subject: Re: [GIT PULL] x86 setup: correct booting on 486 (revised)
References: <200711050358.lA53wlho003349@tazenda.hos.anvin.org>	<alpine.LFD.0.999.0711050842360.15101@woody.linux-foundation.org>	<472F5941.2060507@zytor.com>	<alpine.LFD.0.999.0711051006060.15101@woody.linux-foundation.org>	<472F61C8.4040300@zytor.com>	<alpine.LFD.0.999.0711051035090.15101@woody.linux-foundation.org> <m1pryoa1f6.fsf@ebiederm.dsl.xmission.com> <472F7D8D.8050505@zytor.com> <472F826E.3050008@goop.org> <472F85F2.6040501@zytor.com> <472FBC83.5060509@goop.org> <472FBF40.1010300@zytor.com> <472FC0F3.10102@goop.org> <472FC401.9020202@zytor.com> <47309389.3080403@goop.org> <47309608.9030200@zytor.com>
In-Reply-To: <47309608.9030200@zytor.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> .notes : {
>     *(.note.*)
>     . = ALIGN(4);
>     LONG(0);
>     LONG(0);
>     LONG(0);
> }
>
> Am I missing something?

Oh, I suppose, but I never much liked putting data-definition into the
linker script.

    J

