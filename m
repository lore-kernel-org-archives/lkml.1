Return-Path: <linux-kernel-owner+w=401wt.eu-S1757308AbXHTW31@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308AbXHTW31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2007 18:29:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751481AbXHTW3T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 20 Aug 2007 18:29:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:36209 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751280AbXHTW3S (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2007 18:29:18 -0400
In-Reply-To: <20070820213259.956EB4D05F4@magilla.localdomain>
References: <20070820213259.956EB4D05F4@magilla.localdomain>
Mime-Version: 1.0 (Apple Message framework v623)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Message-Id: <533f74c072dc11b514fe4dc87fd7edc5@kernel.crashing.org>
Content-Transfer-Encoding: 7bit
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Jones <davej@redhat.com>, Paul Mackerras <paulus@samba.org>
From: Segher Boessenkool <segher@kernel.crashing.org>
Subject: Re: [POWERPC] Fix for assembler -g
Date: Tue, 21 Aug 2007 00:29:08 +0200
To: Sam Ravnborg <sam@ravnborg.org>, Roland McGrath <roland@redhat.com>
X-Mailer: Apple Mail (2.623)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>> But there is no lparmap.o!  lparmap.s is the generated file.
>
> Yeah, tell that to scripts/Makefile.lib:
>
> 	_c_flags       = $(CFLAGS) $(EXTRA_CFLAGS) $(CFLAGS_$(basetarget).o)
>
> What would do what a person expects is $(CFLAGS_$(@F)), I think.

Looks good to me.  Sam?  We wanted to set CFLAGS_lparmap.s .


Segher

