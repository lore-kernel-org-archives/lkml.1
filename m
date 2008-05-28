Return-Path: <linux-kernel-owner+w=401wt.eu-S1753659AbYE1Rfi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753659AbYE1Rfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2008 13:35:38 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751910AbYE1Rfa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 May 2008 13:35:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43748 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751696AbYE1Rf3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2008 13:35:29 -0400
Message-ID: <483D97A2.8050802@zytor.com>
Date: Wed, 28 May 2008 10:34:26 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [X86] Fix up silly i1586 boot message.
References: <20080528165713.GA412@redhat.com>
In-Reply-To: <20080528165713.GA412@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones wrote:
> Trying to boot a 64-bit kernel on a 32bit Pentium 4 gets
> you an amusing message along the lines of.
> "you need an x86-64, but you only have an i1586"
> due to the P4 being family F.  Munge it to be 686.
> 
> Signed-off-by: Dave Jones <davej@redhat.com>

Merged; however, if you could in the future use x86: instead of [X86] as 
the prefix, it would save us having to edit it manually.

	-hpa
