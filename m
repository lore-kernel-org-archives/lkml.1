Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab0BJEYi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 23:24:38 -0500
Received: from mail-ww0-f46.google.com ([74.125.82.46]:64365 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751672Ab0BJEYg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 23:24:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=UFmGj+alcSjDgxEhz5hRTmR0sUAoKQxoc0IXcwXi1507jhtv63sYxXEJKrBAEIg0bA
         cFt3cE6o0FBzOD7auIqQdMw9DW78yqK/zhWLNo4+FscuGB5Yfe5eubxxddAKIUsg0vbr
         M7rtlCiK6Ae6piXPrkNouuB+rSKpm0QFA9LQo=
MIME-Version: 1.0
In-Reply-To: <20100210030737.E99A573D8@magilla.sf.frob.com>
References: <20100209201309.902050211@sbs-t61.sc.intel.com>
	 <20100209202502.406177090@sbs-t61.sc.intel.com>
	 <20100210015257.942463E8@magilla.sf.frob.com>
	 <6dc9ffc81002091803o5f5cc632sfd7fad0b41545a97@mail.gmail.com>
	 <20100210030737.E99A573D8@magilla.sf.frob.com>
Date: Tue, 9 Feb 2010 20:24:35 -0800
Message-ID: <6dc9ffc81002092024x3865d856mb92012ad3e1f44cc@mail.gmail.com>
Subject: Re: [patch v2 4/4] ptrace: Add support for generic 
	PTRACE_GETREGSET/PTRACE_SETREGSET
From: "H.J. Lu" <hjl.tools@gmail.com>
To: Roland McGrath <roland@redhat.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Oleg Nesterov <oleg@redhat.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 9, 2010 at 7:07 PM, Roland McGrath <roland@redhat.com> wrote:
>> > There is no need for a global function for this.  It should all be static
>> > in kernel/ptrace.c, called only by ptrace_request()/compat_ptrace_request().
>> >
>>
>> Won't it be called by ptrace emulation in utrace?
>
> I guess I don't really understand the question.  I'm not aware of any
> patches where any such things are done anywhere except the existing
> ptrace_request and compat_ptrace_request functions in kernel/ptrace.c.
>

I guess it isn't needed to be global then.



-- 
H.J.
