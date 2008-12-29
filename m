Return-Path: <linux-kernel-owner+w=401wt.eu-S1752987AbYL2UjF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752987AbYL2UjF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 15:39:05 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753312AbYL2Ugv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 15:36:51 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54112 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbYL2Ugu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 15:36:50 -0500
Message-ID: <495934D9.2070908@zytor.com>
Date: Mon, 29 Dec 2008 12:36:41 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Frysinger <vapier@gentoo.org>
CC: Sam Ravnborg <sam@ravnborg.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: auto-convert size types in userspace headers
References: <49567EB5.5030409@zytor.com> <1230549153-31754-1-git-send-email-vapier@gentoo.org> <20081229140356.GB7327@uranus.ravnborg.org> <200812291534.49577.vapier@gentoo.org>
In-Reply-To: <200812291534.49577.vapier@gentoo.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mike Frysinger wrote:
> On Monday 29 December 2008 09:03:56 Sam Ravnborg wrote:
>> On Mon, Dec 29, 2008 at 06:12:33AM -0500, Mike Frysinger wrote:
>>> Rather than constantly fixing up size type breakage in userspace headers,
>>> auto convert the types u_intXX_t, uintXX_t, intXX_t, uXX, and sXX to the
>>> appropriate __uXX or __sXX type.
>> Is this the right thing to do?
>> uintXX_t belongs to a namespace that the kernel should not use.
> 
> some headers are shared between projects and so use the uintXX_t form, so i'm 
> not sure outright banning it is a nice answer for them

Arguably, the right answer is the opposite... the Linux u* and s* forms
feel much more like nonstandard legacy code to me.  They have the
advantage of brevity, however.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

