Return-Path: <linux-kernel-owner+w=401wt.eu-S933737AbYEBJtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933737AbYEBJtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 May 2008 05:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760093AbYEBJsz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 May 2008 05:48:55 -0400
Received: from one.firstfloor.org ([213.235.205.2]:45650 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759344AbYEBJsy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 May 2008 05:48:54 -0400
Message-ID: <481AE382.4050708@firstfloor.org>
Date: Fri, 02 May 2008 11:48:50 +0200
From: Andi Kleen <andi@firstfloor.org>
User-Agent: Thunderbird 1.5.0.12 (X11/20060911)
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, tglx@linutronix.de,
       sandeen@sandeen.net
Subject: Re: [PATCH] i386: Execute stack overflow warning on interrupt stack
References: <20080502091806.GA26062@basil.nowhere.org> <481AE2A1.7000201@gmail.com>
In-Reply-To: <481AE2A1.7000201@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>> +            : "memory", "cc", "ecx');
> 
> Am I seeing wrong, or is it a ' after the ecx?

No that was the unrefreshed version. I had the patch around for some
time and then updated and noticed Jan's change that added the ecx
clobber and added that one too but unfortunately with typo, which
was then caught, but then forgot to quilt refresh before posting. I
reposted with the correct version now.

Thanks for looking.

-Andi

