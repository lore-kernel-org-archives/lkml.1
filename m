Return-Path: <linux-kernel-owner+w=401wt.eu-S1760145AbYELESR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760145AbYELESR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2008 00:18:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757032AbYELER7
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 May 2008 00:17:59 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:39153 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751558AbYELER5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2008 00:17:57 -0400
X-Sasl-enc: GtxhFxUcyVu1brLoRhwm4RG7aW1XGdsGE4aQFf/ubYdY 1210565876
Date: Mon, 12 May 2008 01:17:53 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Karol Lewandowski <lmctlx@gmail.com>
Subject: Re: [Bug #10670] BUG: linux-2.6.26-rc1 oops at
	thinkpad_acpi:led_set_status
Message-ID: <20080512041753.GA4543@khazad-dum.debian.net>
References: <hPXlJLjt4XG.A._lF.Jv1JIB@chimera> <88YBFoyd1CN.A.qfG.mv1JIB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <88YBFoyd1CN.A.qfG.mv1JIB@chimera>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 11 May 2008, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10670
> Subject		: BUG: linux-2.6.26-rc1 oops at thinkpad_acpi:led_set_status
> Submitter	: Karol Lewandowski <lmctlx@gmail.com>
> Date		: 2008-05-08 23:12 (4 days old)
> References	: http://marc.info/?l=linux-kernel&amp;m=121028841527994&amp;w=4
> Handled-By	: Henrique de Moraes Holschuh <hmh@hmh.eng.br>

It is related to:

1. Debian gcc in stable being used to compile the kernel
2. unmodified led_set_status() function on thinkpad-acpi.c
3. kernel compiled in "optimize for size" mode
4. stack frames NOT being enabled.

Change one, and the bug is gone.

AFAIK, it means Debian stable's gcc is generating bad code.

But I need help from someone with good knowledge of gcc to give us the
final word on it.  I might be doing something stupid in thinkpad-acpi.c,
after all.

I will attach the relevant data to the bug report.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
