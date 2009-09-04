Return-Path: <linux-kernel-owner+w=401wt.eu-S933861AbZIDTI0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933861AbZIDTI0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Sep 2009 15:08:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933827AbZIDTIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 4 Sep 2009 15:08:22 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50041 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933727AbZIDTIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Sep 2009 15:08:22 -0400
Message-ID: <4AA164C0.9080003@zytor.com>
Date: Fri, 04 Sep 2009 12:04:32 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>, Jeff Dike <jdike@addtoit.com>,
       Sam Ravnborg <sam@ravnborg.org>
CC: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
       mingo@redhat.com, tglx@linutronix.de, David.Woodhouse@intel.com,
       linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/kbuild] x86: Don't silently override CONFIG_64BIT in
 'make oldconfig'
References: <tip-5a8a2d13b1526e306ff2a9fe12dc9d5878d355f9@git.kernel.org> <20090904144857.GA12872@elte.hu> <alpine.LFD.2.00.0909041631210.14872@twosheds.infradead.org> <4AA13FE6.20807@zytor.com> <20090904183103.GA1873@elte.hu> <4AA16336.3050606@zytor.com>
In-Reply-To: <4AA16336.3050606@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/04/2009 11:57 AM, H. Peter Anvin wrote:
> 
> Anyway... it sounds like we need to drop this commit for now and
> re-merge it when there is a fix for UM.
> 
> Jeff, Sam, I would appreciate your suggestions as how best to fix this
> kind of stuff...
> 

On that note, this issue isn't just limited to UM.  klibc has to deal
with this issue too: a single kernel architecture may correspond to more
than one user-space architecture, and as far as userspace is concerned,
they are completely different.

	-hpa

