Return-Path: <linux-kernel-owner+w=401wt.eu-S1752591AbZDVXCE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752591AbZDVXCE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Apr 2009 19:02:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751450AbZDVXBx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Apr 2009 19:01:53 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:34069 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751043AbZDVXBw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Apr 2009 19:01:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=qOlwTcj2FEatwmgrQY1jUsHQWdS9MyC3/gjjlrmRGP83CEhMybXb1KjMwphqhar/JM
         Jpj9mnH2amDm8Q37y1PSp5gPoG5YSNvUL12OgLm5rzPUUyVnGE6ct9OAa2zb1gT6sCqf
         +DbsOoblNvjqyJdMEfx0pg7l9O/5Ww+rPTiRk=
MIME-Version: 1.0
In-Reply-To: <20090422220400.GA22755@redhat.com>
References: <20090330185146.D525AFC3AB@magilla.sf.frob.com>
	 <20090408203954.GA26816@redhat.com>
	 <20090416204004.GA28013@redhat.com>
	 <20090416232430.4DAE4FC3C6@magilla.sf.frob.com>
	 <20090420183718.GC32527@redhat.com>
	 <20090421011354.4B19EFC3C7@magilla.sf.frob.com>
	 <20090421214819.GA22845@redhat.com>
	 <20090422032205.B8D39FC3C7@magilla.sf.frob.com>
	 <20090422220400.GA22755@redhat.com>
Date: Wed, 22 Apr 2009 19:01:51 -0400
Message-ID: <8bd0f97a0904221601t110b0dd4xfe1f957de0e3fff7@mail.gmail.com>
Subject: Re: ptracee data structures cleanup
From: Mike Frysinger <vapier.adi@gmail.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Roland McGrath <roland@redhat.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 22, 2009 at 18:04, Oleg Nesterov wrote:
> On 04/21, Roland McGrath wrote:
>> [We have been on fine details here that are quite purely ptrace innards for
>> a while now.  I think discussion at this level of detail about this stuff
>> quite far from utrace per se belongs on LKML.]
>
> Agreed. s/utrace-devel/lkml/.
>
>> > > The clean-up should get rid of PT_DTRACE entirely.
>> >
>> > Agreed. But this needs another patch...
>>
>> Yes, or several.  It always gets fiddly when to get lots of little arch
>> changes merged.  The 90% that are just one-liner removal of wholly unused
>> PT_DTRACE can probably go in as a single patch to Linus instead of tiny
>> ones through each arch tree.
>
> OK. I'd like to finally do at least something. Please look at the 4 patches
> attached.
>
> Unfortunately, I know nothing about these arches, so I can only rely on grep.
> But it really looks like nobody except arch/um actually uses DTRACE.
>
> There are also some strange defines in blackfin and m68k, PF_DTRACE_BIT and
> PT_DTRACE_BIT, which seems to be unused too. At least I failed to find
> anything related in asm. Perhaps I should learn how to cross compile.

Blackfin was based on m68knommu, so it is most likely unused by us.
the only ptrace consumers are gdb(server) and strace and neither use
it afaik.
-mike
