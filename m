Return-Path: <linux-kernel-owner+w=401wt.eu-S932156AbZJUXJy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932156AbZJUXJy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 19:09:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932078AbZJUXJx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 19:09:53 -0400
Received: from qmta01.westchester.pa.mail.comcast.net ([76.96.62.16]:48978
	"EHLO QMTA01.westchester.pa.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932074AbZJUXJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 19:09:52 -0400
X-Greylist: delayed 354 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Oct 2009 19:09:52 EDT
Message-Id: <200910212303.n9LN3vFt000507@deneb.dwf.com>
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.1
To: john stultz <johnstul@us.ibm.com>
cc: James Cloos <cloos@jhcloos.com>, davehart_gmail_exchange_tee@davehart.net,
       hackers@lists.ntp.org, linux-kernel@vger.kernel.org,
       Roman Zippel <zippel@linux-m68k.org>,
       Thomas Gleixner <tglx@linutronix.de>, reg@fw.dwf.com
Subject: Re: [ntp:hackers] ntp-dev-4.2.5p235-RC build failure: MOD_NANO not 
 #defined
In-reply-to: <1256085838.3346.45.camel@localhost> 
References: <m3iqe9kj18.fsf@lugabout.jhcloos.org> <85d954180910201227q528ff210v575df8c1f83e9ada@mail.gmail.com> <1f1b08da0910201345w61f1bb4yb99b5f052ea77ac4@mail.gmail.com> <m3aazlk5vz.fsf@lugabout.jhcloos.org> <1256085838.3346.45.camel@localhost>
Comments: In-reply-to john stultz <johnstul@us.ibm.com>
   message dated "Tue, 20 Oct 2009 17:43:58 -0700."
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date: Wed, 21 Oct 2009 17:03:57 -0600
From: Reg Clemens <reg@dwf.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Isnt it just time to get rid of these MOD_ constructs in ntp?

A quick find/grep of the code shows that there are only 7 usages left
in the ntpd main line.

There are 2 in tickadj.

There are 15 in ntptime.

It would take less time to change these to the STA_*** forms than
to see this question ever come up again.

-- 
                                        Reg.Clemens
                                        reg@dwf.com


