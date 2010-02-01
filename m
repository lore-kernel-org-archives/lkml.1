Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752285Ab0BAQpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Feb 2010 11:45:50 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54702 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751016Ab0BAQps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Feb 2010 11:45:48 -0500
Message-ID: <4B6703EF.9050306@zytor.com>
Date: Mon, 01 Feb 2010 08:40:15 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc11 Thunderbird/3.0.1
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: mingo@elte.hu, jeremy@goop.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/3] x86: enlightenment for ticket spinlocks
References: <4B65C5BE02000078000584B5@vpn.id2.novell.com> <4B65CF5B.3000804@zytor.com> <4B669742020000780002CEEB@vpn.id2.novell.com>
In-Reply-To: <4B669742020000780002CEEB@vpn.id2.novell.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/2010 11:56 PM, Jan Beulich wrote:
>>
>> It's probably a bug that's now cast in stone.  That happends.  I just
>> had to be picky.  (And yes, it's ebx-edx-ecx; see my second email.)
> 
> The "good" thing is that this is not on leaf 0, but on leaf 0x4000??00,
> i.e. "normal" code would never display this garbled string.
> 

Well, yes, but the format of ID leaves is the same between groups.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

