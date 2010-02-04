Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756281Ab0BDJec (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 04:34:32 -0500
Received: from vpn.id2.novell.com ([195.33.99.129]:15848 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756135Ab0BDJea convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;8:2>);
	Thu, 4 Feb 2010 04:34:30 -0500
Message-Id: <4B6AA2D6020000780002DAD1@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Thu, 04 Feb 2010 09:35:02 +0000
From: "Jan Beulich" <JBeulich@novell.com>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: "Ingo Molnar" <mingo@elte.hu>, "Dan Carpenter" <error27@gmail.com>,
       <bernhard.kaindl@gmx.net>, "Thomas Gleixner" <tglx@linutronix.de>,
       <linux1394-devel@lists.sourceforge.net>,
       "Stefan Richter" <stefanr@s5r6.in-berlin.de>,
       "Rafael Wysocki" <rjw@sisk.pl>,
       "Kernel Testers List" <kernel-testers@vger.kernel.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       <ebiderman@xmission.com>, <hpa@zytor.com>
Subject: Re: ohci1394_dma=early crash since 2.6.32 (was Re: [Bug
	 #14487] PANIC: early exception 08 rip 246:10 error
	 ffffffff810251b5 cr2 0)
References: <UgwvXSBS_tM.A.alD.1EiZLB@chimera>
 <de962C6zBxL.A.H1G.1HiZLB@chimera> <4B6630CA.9010207@gmail.com>
 <20100201125441.GB2576@bicker> <4B671606.3080405@gmail.com>
 <4B673233.8000300@s5r6.in-berlin.de> <4B6740B5.5070601@gmail.com>
 <4B675534.5070107@s5r6.in-berlin.de> <4B676917.2080506@gmail.com>
 <4B67BC12.4080709@s5r6.in-berlin.de> <4B67C4D2.5050205@gmail.com>
 <4B67CC55.40301@s5r6.in-berlin.de> <4B67CCEC.2030103@s5r6.in-berlin.de>
 <4B68D4CA.2010803@gmail.com> <4B694D5C020000780002D6DA@vpn.id2.novell.com>
 <4B6A0123.3010607@gmail.com> <4B6A9960020000780002DA6B@vpn.id2.novell.com>
 <4B6A8DA9.4090804@gmail.com> <4B6A9D4C020000780002DA99@vpn.id2.novell.com>
 <4B6A90BB.7090405@gmail.com>
In-Reply-To: <4B6A90BB.7090405@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> "Justin P. Mattock" <justinmattock@gmail.com> 04.02.10 10:17 >>>
>so something is using __native_set_fixmap
>that's hitting some memory address then
>set_fixmap_nocache(ohci1394_dma=early)
>fires off hitting the same?

No, afaict it is the ohci1394_dma=early code itself hitting that path.

Jan

