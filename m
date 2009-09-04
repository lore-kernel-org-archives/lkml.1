Return-Path: <linux-kernel-owner+w=401wt.eu-S1757068AbZIDQPj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757068AbZIDQPj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 12:15:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757019AbZIDQPj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 12:15:39 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46784 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185AbZIDQPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 12:15:38 -0400
Message-ID: <4AA13C9D.2000401@zytor.com>
Date: Fri, 04 Sep 2009 09:13:17 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Tejun Heo <tj@kernel.org>, mingo@redhat.com, linux-kernel@vger.kernel.org,
       jeremy.fitzhardinge@citrix.com, stable@kernel.org, tglx@linutronix.de,
       mingo@elte.hu, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86/i386: Make sure stack-protector segment base
 is cache aligned
References: <4AA01893.6000507@goop.org> <tip-1ea0d14e480c245683927eecc03a70faf06e80c8@git.kernel.org> <4AA02687.9080406@zytor.com> <4AA02B02.7080101@goop.org> <4AA031DE.2070109@zytor.com> <4AA080A0.7010804@kernel.org> <4AA08283.5020306@kernel.org> <4AA08B09.50503@zytor.com> <4AA08DD3.5010509@kernel.org> <4AA08ED0.4050206@zytor.com> <4AA0A05B.5010806@kernel.org> <4AA13A8C.2080709@goop.org>
In-Reply-To: <4AA13A8C.2080709@goop.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2009 09:04 AM, Jeremy Fitzhardinge wrote:
> 
> Ideally we'd like to get rid of the constant offset too.  If we could
> change it to %[fg]s:__gcc_stack_canary_offset on both 32-bit and 64-bit,
> it would give us a lot more flexibility.  __gcc_stack_canary_offset
> could be weakly defined to 20/40 for backwards compatibility, but we
> could override it to point to a normal percpu variable.
> 

Yes, although that definitely means starting the gcc pipeline from scratch.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

