Return-Path: <linux-kernel-owner+w=401wt.eu-S1761188AbXLTNTu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761188AbXLTNTu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Dec 2007 08:19:50 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753959AbXLTNTl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Dec 2007 08:19:41 -0500
Received: from metis.extern.pengutronix.de ([83.236.181.26]:56740 "EHLO
	metis.extern.pengutronix.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754155AbXLTNTk convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Dec 2007 08:19:40 -0500
From: Juergen Beisert <jbe@pengutronix.de>
Organization: Pengutronix - Linux Solutions for Science and Industry
To: linux-rt-users@vger.kernel.org
Date: Thu, 20 Dec 2007 14:18:16 +0100
User-Agent: KMail/1.9.4
Cc: "Jaswinder Singh" <jaswinderlinuxrt@gmail.com>,
       "Remy Bohmer" <linux@bohmer.net>,
       "Steven Rostedt" <rostedt@goodmis.org>,
       "Arnaldo Carvalho de Melo" <acme@ghostprotocols.net>,
       "Ingo Molnar" <mingo@elte.hu>, "Darren Hart" <dvhltc@us.ibm.com>,
       "Sven-Thorsten Dietrich" <sdietrich@novell.com>,
       LKML <linux-kernel@vger.kernel.org>
References: <20071219194551.315868746@bohmer.net> <3efb10970712200425x4b0ffadcpd2ffa3223eda7b3d@mail.gmail.com> <1985e0f60712200445o4f854cdep6eebf1726737229b@mail.gmail.com>
In-Reply-To: <1985e0f60712200445o4f854cdep6eebf1726737229b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200712201418.17378.jbe@pengutronix.de>
X-SA-Exim-Connect-IP: 83.236.181.29
X-SA-Exim-Mail-From: jbe@pengutronix.de
Subject: Re: [patch 3/3] Enable setting of IRQ-thread priorities from kernel cmdline. (repost:CC to LKML)
X-SA-Exim-Version: 4.2.1 (built Tue, 09 Jan 2007 17:23:22 +0000)
X-SA-Exim-Scanned: Yes (on metis.extern.pengutronix.de)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 20 December 2007 13:45, Jaswinder Singh wrote:
> On 12/20/07, Remy Bohmer <linux@bohmer.net> wrote:
> > So, Is this a serious requirement? Should this be possible?
>
> I have noticed this problem:
> root@192.168.1.253:~# cat /proc/loadavgrt
> 1.00 1.00 1.00 0/52 1158
> root@192.168.1.253:~# cat /proc/loadavg
> 0.00 0.00 0.02 1/52 1159
> root@192.168.1.253:~#
>
> So I am curious, if possible, user can switch softirq-threads or IRQs
> RT tasks to non-RT tasks for slow hardware or least important hardware
> for NON-RT tasks. So this will improve RT behaviour.
                    ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Why?

IMHO: Simply decrease the RT priority of less important IRQs or increase all 
other more important IRQs. IRQs are always more important than other 
processes in a system, also in non RT systems.

Juergen
-- 
Dipl.-Ing. Juergen Beisert | http://www.pengutronix.de
 Pengutronix - Linux Solutions for Science and Industry
    Handelsregister: Amtsgericht Hildesheim, HRA 2686
         Vertretung Sued/Muenchen, Germany
   Phone: +49-8766-939 228 |  Fax: +49-5121-206917-9
