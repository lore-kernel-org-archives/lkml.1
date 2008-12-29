Return-Path: <linux-kernel-owner+w=401wt.eu-S1753788AbYL2XgA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753788AbYL2XgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2008 18:36:00 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYL2Xfw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 29 Dec 2008 18:35:52 -0500
Received: from terminus.zytor.com ([198.137.202.10]:52558 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751448AbYL2Xfv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2008 18:35:51 -0500
Message-ID: <49595ED1.2080701@zytor.com>
Date: Mon, 29 Dec 2008 15:35:45 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
CC: Mike Frysinger <vapier@gentoo.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: auto-convert size types in userspace headers
References: <49567EB5.5030409@zytor.com> <1230549153-31754-1-git-send-email-vapier@gentoo.org> <20081229140356.GB7327@uranus.ravnborg.org>
In-Reply-To: <20081229140356.GB7327@uranus.ravnborg.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sam Ravnborg wrote:
> On Mon, Dec 29, 2008 at 06:12:33AM -0500, Mike Frysinger wrote:
>> Rather than constantly fixing up size type breakage in userspace headers,
>> auto convert the types u_intXX_t, uintXX_t, intXX_t, uXX, and sXX to the
>> appropriate __uXX or __sXX type.
> 
> Is this the right thing to do?
> uintXX_t belongs to a namespace that the kernel should not use.
> 
> So being restrictive here would be better I think.

That's the whole point right here.

All of these types can be -- and are -- used by the kernel internally,
but should only be exported as __uXX or __sXX.

This is the auto-conversion idea I brought up earlier.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

