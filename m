Return-Path: <linux-kernel-owner+w=401wt.eu-S1757824AbYEBEez@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824AbYEBEez (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 00:34:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750984AbYEBEes
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 00:34:48 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48270 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750821AbYEBEer (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 00:34:47 -0400
Message-ID: <481A992D.4070807@zytor.com>
Date: Thu, 01 May 2008 21:31:41 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: hpa@zytor.com, linux-kernel@vger.kernel.org
Subject: Re: kernel/time.c: integer constant is too large for long type
References: <20080502024636.GA31465@beyonder.ift.unesp.br>
In-Reply-To: <20080502024636.GA31465@beyonder.ift.unesp.br>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Carlos R. Mafra wrote:
> Hi Peter,
> 
> I would like to report a gcc warning which caught my attention today:
> 
> kernel/time.c: In function msecs_to_jiffies:
> kernel/time.c:479: warning: integer constant is too large for long type
> kernel/time.c: In function usecs_to_jiffies:
> kernel/time.c:494: warning: integer constant is too large for long type
> 
> and ask you if this is something I should worry about (and propose
> a patch if this warning is harmless).
> 
> I ask this because this warning was introduced via commit 
> bdc807871d58285737d50dc6163d0feb72cb0dc2 ("avoid overflows in kernel/time.c")
> and (naively) for me it looks like the above gcc warning is some kind of 
> overflow.
> 

Hi there,

The code is correct if a bit subtle.  I have put a fix of it as part of 
a larger patch series at:

git://git.kernel.org/pub/scm/linux/kernel/git/hpa/linux-2.6-inttypes.git

Your patch is simpler, so if Linus doesn't take the patch series this 
window we should push your patch after the window closes.

	-hpa
