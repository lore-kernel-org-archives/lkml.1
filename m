Return-Path: <linux-kernel-owner+w=401wt.eu-S1752523AbYJaRzr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752523AbYJaRzr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2008 13:55:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751170AbYJaRzj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 31 Oct 2008 13:55:39 -0400
Received: from ey-out-2122.google.com ([74.125.78.25]:35131 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750960AbYJaRzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2008 13:55:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=Y0McYJJ3ztEdgfS7T7jM0lks0Ei5oAD7Sg0vdT1aBwISq5lFq7P1RHr2+ncWFHbupX
         qzpT5+/kPwp/7Qun7sGXP3TYjGWtQ+fsyg07zejys+BmLp2onSOUboBnHg9iPLFxhcmO
         6JSQa74nRgw99fN2IEBPkt69bVpLkZhXhTDvM=
Date: Fri, 31 Oct 2008 17:55:04 +0000
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Toralf =?utf-8?Q?F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: build issue #576 for v2.6.28-rc2-385-g721d5df :'boot_cpu_id'
	undeclared
Message-ID: <20081031175504.GG3235@hack.voiplan.pt>
References: <200810311702.36706.toralf.foerster@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <200810311702.36706.toralf.foerster@gmx.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2008 at 05:02:33PM +0100, Toralf Förster wrote:
>Hello,
>
>the build (.config attached) failed, make ends with :
>...
>  CC      arch/x86/kernel/cpu/capflags.o
>  CC      arch/x86/kernel/cpu/powerflags.o
>  CC      arch/x86/kernel/cpu/common.o
>arch/x86/kernel/cpu/common.c: In function 'cpu_init':
>arch/x86/kernel/cpu/common.c:1141: error: 'boot_cpu_id' undeclared (first use 
>in this function)
>arch/x86/kernel/cpu/common.c:1141: error: (Each undeclared identifier is 
>reported only once
>arch/x86/kernel/cpu/common.c:1141: error: for each function it appears in.)
>make[2]: *** [arch/x86/kernel/cpu/common.o] Error 1
>make[1]: *** [arch/x86/kernel/cpu] Error 2
>make: *** [arch/x86/kernel] Error 2

Probably fixed by:

http://lkml.org/lkml/2008/10/30/459

-- 
"Sometimes the only way to stay sane is to go a little crazy."

