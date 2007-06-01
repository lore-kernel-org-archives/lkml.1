Return-Path: <linux-kernel-owner+w=401wt.eu-S1761314AbXFAMVo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761314AbXFAMVo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2007 08:21:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760590AbXFAMVc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Jun 2007 08:21:32 -0400
Received: from wr-out-0506.google.com ([64.233.184.232]:54119 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761070AbXFAMV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2007 08:21:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding:from;
        b=i8iK1VBZurso54Mf1Jjuz6qpM77e6wukWQhNsi5RR/bElhW2VlrESiwssXpfHJP6usrgYHX7ZqFp14NZVz7996rXLcVHU4F1rZIZz3oXMZlBq2cl9CWSAP3fejoJz8CWPbMkBA7DsCbkWCsZGzJKLEhXDQSa1wLf7o9hM8wVjYo=
Message-ID: <46600F27.1090202@googlemail.com>
Date: Fri, 01 Jun 2007 14:20:55 +0200
User-Agent: Thunderbird 1.5.0.10 (X11/20070302)
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>, linux-pcmcia@lists.infradead.org,
       Robert de Rooy <robert.de.rooy@gmail.com>, Alan Cox <alan@redhat.com>,
       Tejun Heo <htejun@gmail.com>, linux-ide@vger.kernel.org,
       Jeff Garzik <jeff@garzik.org>, Gregor Jasny <gjasny@googlemail.com>,
       linux-scsi@vger.kernel.org,
       James Bottomley <James.Bottomley@SteelEye.com>,
       Mark Salyzyn <aacraid@adaptec.com>, Yinghai Lu <yhlu.kernel@gmail.com>,
       Vivek Goyal <vgoyal@in.ibm.com>, sparclinux@vger.kernel.org,
       David Miller <davem@davemloft.net>, Mikael Pettersson <mikpe@it.uu.se>
Subject: Re: [2/3] 2.6.22-rc3: known regressions v2
References: <465FED20.3090206@googlemail.com>
In-Reply-To: <465FED20.3090206@googlemail.com>
X-Enigmail-Version: 0.94.1.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit
From: Michal Piotrowski <michal.k.k.piotrowski@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Here is a list of some known regressions in 2.6.22-rc3.

Feel free to add new regressions/remove fixed etc.
http://kernelnewbies.org/known_regressions



PCMCIA

Subject    : libata and legacy ide pcmcia failure
References : http://lkml.org/lkml/2007/5/17/305
Submitter  : Robert de Rooy <robert.de.rooy@gmail.com>
Status     : Unknown



SATA/PATA

Subject    : 22-rc3 broke the CDROM in Dell notebook
References : http://lkml.org/lkml/2007/5/27/63
Submitter  : Gregor Jasny <gjasny@googlemail.com>
Handled-By : Tejun Heo <htejun@gmail.com>
             Jeff Garzik <jeff@garzik.org>
Caused-By  : Tejun Heo <htejun@gmail.com>
             commit d4b2bab4f26345ea1803feb23ea92fbe3f6b77bc
Status     : problem is being debugged



SCSI

Subject    : aacraid: adapter kernel panic'd fffffffd (kexec)
References : http://lkml.org/lkml/2007/5/29/491
Submitter  : Yinghai Lu <yhlu.kernel@gmail.com>
Handled-By : Salyzyn, Mark <mark_salyzyn@adaptec.com>
             Vivek Goyal <vgoyal@in.ibm.com>
Status     : problem is being debugged



Sparc64

Subject    : 2.6.22-rc broke X on Ultra5
References : http://lkml.org/lkml/2007/5/22/78
Submitter  : Mikael Pettersson <mikpe@it.uu.se>
Handled-By : David Miller <davem@davemloft.net>
Status     : problem is being debugged



Regards,
Michal

--
"Najbardziej brakowa³o mi twojego milczenia."
-- Andrzej Sapkowski "Co¶ wiêcej"


