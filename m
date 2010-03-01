Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752003Ab0CATQk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Mar 2010 14:16:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57281 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751820Ab0CATQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Mar 2010 14:16:39 -0500
Message-ID: <4B8C11DC.1060004@third-harmonic.com>
Date: Mon, 01 Mar 2010 14:13:32 -0500
From: john cooper <john.cooper@third-harmonic.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Takuya Yoshikawa <yoshikawa.takuya@oss.ntt.co.jp>,
       linux-kernel@vger.kernel.org, mingo@elte.hu, avi@redhat.com,
       mtosatti@redhat.com, zamsden@redhat.com,
       john cooper <john.cooper@third-harmonic.com>
Subject: Re: use of setjmp/longjmp in x86 emulator.
References: <20100301091819.GD16909@redhat.com> <4B8BB6FA.1000505@oss.ntt.co.jp> <20100301125223.GI16909@redhat.com> <4B8BBE61.3020503@oss.ntt.co.jp> <20100301132609.GJ16909@redhat.com>
In-Reply-To: <20100301132609.GJ16909@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gleb Natapov wrote:

> Think about what happens if in the middle of
> instruction emulation some data from device emulated in userspace is
> needed. Emulator should be able to tell KVM that exit to userspace is
> needed and restart instruction emulation when data is available.

setjmp/longjmp are useful constructs in general but
IME are better suited for infrequent exceptions vs.
routine usage.

If the issue is finding some clean and regular way
to back out from (and possibly reeneter) logic
expressed within nested function invocations, have
you considered turning the problem inside out and
using a state machine approach?      

-- 
john.cooper@third-harmonic.com
