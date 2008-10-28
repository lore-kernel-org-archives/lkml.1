Return-Path: <linux-kernel-owner+w=401wt.eu-S1752814AbYJ1HMK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752814AbYJ1HMK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2008 03:12:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751685AbYJ1HL4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 28 Oct 2008 03:11:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:59234 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751536AbYJ1HLz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2008 03:11:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.33,497,1220252400"; 
   d="scan'208";a="632336868"
Subject: Re: Linux 2.6.28-rc1] ACPI Warning (nspredef-0852)[...]
From: Zhao Yakui <yakui.zhao@intel.com>
To: Maciej Rutecki <maciej.rutecki@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Robert Hancock <hancockr@shaw.ca>,
       Henrique de Moraes Holschuh <hmh@hmh.eng.br>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
       "lenb@kernel.org" <lenb@kernel.org>,
       "fabio.comolli@gmail.com" <fabio.comolli@gmail.com>
In-Reply-To: <8db1092f0810271319s5d15c2ffrab37a548fa388738@mail.gmail.com>
References: <fa.1HaqObZirROiyqr922A7hRDVc54@ifi.uio.no>
	 <fa.Rzh43vSl9NX1QQ2nOYQSgEJcZAw@ifi.uio.no> <49035313.9080309@shaw.ca>
	 <200810252004.01274.rjw@sisk.pl>
	 <8db1092f0810251151l4c7f9382r34defa6d4d6ee24c@mail.gmail.com>
	 <8db1092f0810271319s5d15c2ffrab37a548fa388738@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 28 Oct 2008 15:18:18 +0800
Message-Id: <1225178298.5189.138.camel@yakui_zhao.sh.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.0 (2.8.0-7.fc6) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2008-10-27 at 13:19 -0700, Maciej Rutecki wrote:
> 2008/10/25 Maciej Rutecki <maciej.rutecki@gmail.com>:
> > Suspend to ram, but another machine (previous PC, now laptop) and
> > another problem:
> >
> > ACPI: EC: missing confirmations, switch off interrupt mode.
> > ACPI Exception (evregion-0419): AE_TIME, Returned by Handler for
> > [EmbeddedControl] [20080926]
> > ACPI Error (psparse-0524): Method parse/execution failed [\_TZ_.C31E]
> > (Node f7019858), AE_TIME
> > ACPI Error (psparse-0524): Method parse/execution failed
> > [\_TZ_.TZ3_._TMP] (Node f7019ed0), AE_TIME
> >
> > It doesn't happened immediately after s2ram but is correlation between
> > s2ram and this error.
Will you please confirm whether the following issue exists on the
previous kernel? For example: 2.6.27-rc6 or 2.6.27.2
 
> ACPI Exception (evregion-0419): AE_TIME, Returned by Handler for
> [EmbeddedControl] [20080926]
> ACPI Error (psparse-0524): Method parse/execution failed [\_TZ_.C31E]
> (Node f7019858), AE_TIME
> ACPI Error (psparse-0524): Method parse/execution failed
> [\_TZ_.TZ3_._TMP] (Node f7019ed0), AE_TIME
   
If there is no such problem on the early kernel, maybe it is a
regression.

Thanks.
> I was wrong; it happens not only after suspend to ram but sometimes
> after normal boot.
> 
> 

