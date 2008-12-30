Return-Path: <linux-kernel-owner+w=401wt.eu-S1753393AbYL3RnJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393AbYL3RnJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2008 12:43:09 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbYL3Rm4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Dec 2008 12:42:56 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44836 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751446AbYL3Rmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2008 12:42:55 -0500
Message-ID: <495A5D97.7070706@zytor.com>
Date: Tue, 30 Dec 2008 09:42:47 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: auto-convert size types in userspace headers
References: <49567EB5.5030409@zytor.com> <1230549153-31754-1-git-send-email-vapier@gentoo.org> <20081229140356.GB7327@uranus.ravnborg.org> <49595ED1.2080701@zytor.com> <20081230104351.GB486@uranus.ravnborg.org>
In-Reply-To: <20081230104351.GB486@uranus.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Mon, Dec 29, 2008 at 03:35:45PM -0800, H. Peter Anvin wrote:
>> Sam Ravnborg wrote:
>>> On Mon, Dec 29, 2008 at 06:12:33AM -0500, Mike Frysinger wrote:
>>>> Rather than constantly fixing up size type breakage in userspace headers,
>>>> auto convert the types u_intXX_t, uintXX_t, intXX_t, uXX, and sXX to the
>>>> appropriate __uXX or __sXX type.
>>> Is this the right thing to do?
>>> uintXX_t belongs to a namespace that the kernel should not use.
>>>
>>> So being restrictive here would be better I think.
>> That's the whole point right here.
>>
>> All of these types can be -- and are -- used by the kernel internally,
>> but should only be exported as __uXX or __sXX.
>>
>> This is the auto-conversion idea I brought up earlier.
> 
> So the patch from Mike has your "Acked-by"?
> 

Acked-by: H. Peter Anvin <hpa@zytor.com>

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

