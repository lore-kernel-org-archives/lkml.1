Return-Path: <linux-kernel-owner+w=401wt.eu-S1762696AbZD3QbC@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762696AbZD3QbC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 12:31:02 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754095AbZD3Qav
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 12:30:51 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33781 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751940AbZD3Qau (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 12:30:50 -0400
Message-ID: <49F9D1E5.2090805@zytor.com>
Date: Thu, 30 Apr 2009 09:29:25 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: mingo@redhat.com, linux-kernel@vger.kernel.org,
       torvalds@linux-foundation.org, tglx@linutronix.de, jdb@comx.dk,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kbuild] x86: boot/compressed/vmlinux.lds.S: fix build
 of bzImage with 64 bit compiler
References: <alpine.LFD.2.00.0904260958190.3101@localhost.localdomain> <tip-83c4832683bc8ebcd1687b3c0bf3ba1ab253dd4f@git.kernel.org> <49F9BB47.7080806@zytor.com> <20090430150924.GA8656@uranus.ravnborg.org>
In-Reply-To: <20090430150924.GA8656@uranus.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
>>>
>> I'm wondering if we should build the *.lds.S with -ansi or some other
>> gcc option which disables ALL non-underscore macros.
> 
> I did not know that -ansi had this effect.
> We are only seldomly hitting this issue and I wonder
> if it could break something in out included headers.
> Most likely not.
> 

The other thing to recognize is probably that lds files aren't assembly,
they're something else entirely.  Rather than reusing the *.S rules,
having specific rules for them probably would make sense.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

