Return-Path: <linux-kernel-owner+w=401wt.eu-S1755163AbYGWJkP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755163AbYGWJkP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2008 05:40:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYGWJkD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 23 Jul 2008 05:40:03 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:25760 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbYGWJkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2008 05:40:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject:references
         :in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=ZTcNLx5xqvKbaTzXX7PPAL6gAPv075R3leUHSd/uYwPtA/1AkRi7QwXyzAw5kbIdQ+
         2uCnWG/p8TqZCsOuUXC/nbSgquYqYsj+KNvPYQIwp/5BqElBujSBBqa3OyYgVPB7Ff/D
         SFkdq7yhARuLac7n5E6L8Ml+GUJXzZrS+jABg=
Message-ID: <4886FBEF.5030706@gmail.com>
Date: Wed, 23 Jul 2008 11:37:51 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080421)
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Linux Memory Management List <linux-mm@kvack.org>,
       Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: WARNING: at arch/x86/mm/pageattr.c:591 __change_page_attr_set_clr
 [mmotm]
References: <4886FA7C.8060809@gmail.com>
In-Reply-To: <4886FA7C.8060809@gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/23/2008 11:31 AM, Jiri Slaby wrote:
> mmotm 2008-07-15-15-39 while booting:
> 
> EXT3 FS on dm-0, internal journal
> EXT3-fs: mounted filesystem with ordered data mode.
> ------------[ cut here ]------------
> WARNING: at arch/x86/mm/pageattr.c:591 
> __change_page_attr_set_clr+0x627/0x990()
> CPA: called for zero pte. vaddr = ffff88007d5b0000 cpa->vaddr = 
> ffff88007d5b0000

Hmm, I think it's known:
http://marc.info/?l=linux-acpi&m=121607842728729&w=2

