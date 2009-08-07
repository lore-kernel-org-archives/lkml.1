Return-Path: <linux-kernel-owner+w=401wt.eu-S1757602AbZHGLuX@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602AbZHGLuX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:50:23 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757178AbZHGLuX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:50:23 -0400
Received: from co203.xi-lite.net ([149.6.83.203]:50507 "EHLO co203.xi-lite.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751144AbZHGLuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:50:22 -0400
Message-ID: <4A7C14EB.1060701@parrot.com>
Date: Fri, 7 Aug 2009 13:50:03 +0200
From: Matthieu CASTET <matthieu.castet@parrot.com>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20090701)
MIME-Version: 1.0
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
CC: Alain Knaff <alain@knaff.lu>,
       Russell King - ARM Linux <linux@arm.linux.org.uk>,
       "sam@ravnborg.org" <sam@ravnborg.org>, "hpa@zytor.com" <hpa@zytor.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-embedded@vger.kernel.org" <linux-embedded@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: [PATCH 4/6] Add support for LZO-compressed kernels for ARM
References: <20090731093107.GA29704@merkur.ravnborg.org> <1249311501-23102-1-git-send-email-albin.tonnerre@free-electrons.com> <1249311501-23102-2-git-send-email-albin.tonnerre@free-electrons.com> <1249311501-23102-3-git-send-email-albin.tonnerre@free-electrons.com> <1249311501-23102-4-git-send-email-albin.tonnerre@free-electrons.com> <20090806224055.GH31579@n2100.arm.linux.org.uk> <20090807092423.GA4455@laptop> <4A7BF5B8.4030907@knaff.lu> <20090807102117.GB4455@laptop>
In-Reply-To: <20090807102117.GB4455@laptop>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Albin Tonnerre a écrit :
> On Fri, Aug 07, 2009 at 11:36:56AM +0200, Alain Knaff wrote :
>> On 08/07/09 11:24, Albin Tonnerre wrote:
> 
>>> Regards,
> 
>> Could it be that the patches that remove division (zutil.h and inflate.c)
>> have somehow not been applied?
> 
> Indeed, they've not been applied. However, I'd rather try to understand why
> exactly this is an issue when compiling with -Os and not -O2 instead of working
> around it by removing the divisions.
> 
Look at the generated code.

Arm doesn't have division instruction.
May be at -Os gcc emit a call to the software division, but at -O2 it
manage to optimise the division (transform it in shift, inline some
builtin, ...).


Matthieu
