Return-Path: <linux-kernel-owner+w=401wt.eu-S1757564AbZHGL3f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564AbZHGL3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Aug 2009 07:29:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757178AbZHGL3f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 7 Aug 2009 07:29:35 -0400
Received: from crmm.lgl.lu ([158.64.72.228]:58126 "EHLO lll.lu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756081AbZHGL3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Aug 2009 07:29:34 -0400
Message-ID: <4A7C1005.7010808@knaff.lu>
Date: Fri, 07 Aug 2009 13:29:09 +0200
From: Alain Knaff <alain@knaff.lu>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Albin Tonnerre <albin.tonnerre@free-electrons.com>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>, sam@ravnborg.org,
       hpa@zytor.com, linux-kernel@vger.kernel.org,
       linux-embedded@vger.kernel.org, akpm@linux-foundation.org
Subject: Re: [PATCH 4/6] Add support for LZO-compressed kernels for ARM
References: <20090731093107.GA29704@merkur.ravnborg.org> <1249311501-23102-1-git-send-email-albin.tonnerre@free-electrons.com> <1249311501-23102-2-git-send-email-albin.tonnerre@free-electrons.com> <1249311501-23102-3-git-send-email-albin.tonnerre@free-electrons.com> <1249311501-23102-4-git-send-email-albin.tonnerre@free-electrons.com> <20090806224055.GH31579@n2100.arm.linux.org.uk> <20090807092423.GA4455@laptop> <4A7BF5B8.4030907@knaff.lu> <20090807102117.GB4455@laptop>
In-Reply-To: <20090807102117.GB4455@laptop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/09 12:21, Albin Tonnerre wrote:

> Indeed, they've not been applied. However, I'd rather try to understand why
> exactly this is an issue when compiling with -Os and not -O2 instead of working
> around it by removing the divisions.
> 
> Regards,

Well, I for myself couldn't get it to compile _at_all_ for ARM as long as
there were any division operations in the code. My theory was that the ARM
processor doesn't have native division, and that this is being supplied by
some kind of run-time library, which is not linked with when building the
pre-boot environment. But if it works with some compilation flags but not
others, something more complex must be going on...

... or could it be that with some flags, the compiler generates "division
emulation" code, but not with others (such as when optimizing for size?)

Regards,

Alain
