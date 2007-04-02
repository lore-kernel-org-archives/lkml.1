Return-Path: <linux-kernel-owner+w=401wt.eu-S1752083AbXDBCix@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbXDBCix (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2007 22:38:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752109AbXDBCiw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 1 Apr 2007 22:38:52 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:34354 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752083AbXDBCiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2007 22:38:51 -0400
X-Sasl-enc: 61OGHxq/P1b5ok+56cN8blx/b5HHG8k5mzfHSfbInzm8 1175481531
Date: Sun, 1 Apr 2007 23:38:46 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: Alexey Starikovskiy <aystarik@gmail.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org, Ingo Molnar <mingo@elte.hu>
Subject: Re: 2.6.21-rc5: Thinkpad X60 gets critical thermal shutdowns
Message-ID: <20070402023846.GC28561@khazad-dum.debian.net>
References: <460E0158.7090705@goop.org> <8f8ff01d0703310033y74421cfcl747ece1be003471@mail.gmail.com> <460F511E.2090102@goop.org> <46103DF2.30001@goop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <46103DF2.30001@goop.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 01 Apr 2007, Jeremy Fitzhardinge wrote:
> control problems.  Perhaps the ambient temperature was lower when I
> reported success.

You can use ibm-acpi to properly track your thinkpad thermal sensors, load
it with the "experimental=1" parameter, and look at what gets exported at
/proc/acpi/ibm/thermal.

You can also use /proc/acpi/ibm/fan to check the fan's state.  And use the
"level 7" /proc/acpi/ibm/fan command to set the emergency cooling level, and
"level disengaged" command to set the really badass fan cooling level (might
damage your hardware, we don't know if it is safe and IBM/Lenovo isn't
talking).

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
