Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752632Ab0BTG1w (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Feb 2010 01:27:52 -0500
Received: from mail.vyatta.com ([76.74.103.46]:55418 "EHLO mail.vyatta.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752039Ab0BTG1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Feb 2010 01:27:50 -0500
Date: Fri, 19 Feb 2010 22:27:28 -0800
From: Stephen Hemminger <shemminger@vyatta.com>
To: Cong Wang <amwang@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       "Luis R. Rodriguez" <lrodriguez@atheros.com>,
       Sam Ravnborg <sam@ravnborg.org>,
       Vegard Nossum <vegard.nossum@gmail.com>,
       Uwe =?UTF-8?B?S2xlaW5lLUvDg8K2bmln?= 
	<u.kleine-koenig@pengutronix.de>,
       "Robert P. J. Day" <rpjday@crashcourse.ca>,
       Arnd Bergmann <arnd@arndb.de>, Arjan van de Ven <arjan@linux.intel.com>,
       Hui Zhu <teawater@gmail.com>,
       Ozan =?UTF-8?B?w4NhZ2xheWFu?= <ozan@pardus.org.tr>,
       Matthew Wilcox <willy@linux.intel.com>,
       Steven Rostedt <rostedt@goodmis.org>, Li Hong <lihong.hi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Ralf Baechle <ralf@linux-mips.org>,
       Matt Fleming <matt@console-pimps.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/10] namespace: perlcritic warnings
Message-ID: <20100219222728.5805f865@nehalam>
In-Reply-To: <4B7F534E.7040108@redhat.com>
References: <20100219175217.385580142@vyatta.com>
	<20100219175429.826376846@vyatta.com>
	<4B7F534E.7040108@redhat.com>
Organization: Vyatta
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If objdump program is missing program should die with message
to standard error and exit with non zero status, not continue on!
