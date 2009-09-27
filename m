Return-Path: <linux-kernel-owner+w=401wt.eu-S1753923AbZI0M2a@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753923AbZI0M2a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Sep 2009 08:28:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753899AbZI0M23
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Sep 2009 08:28:29 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:46740 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753894AbZI0M22 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Sep 2009 08:28:28 -0400
X-Sasl-enc: XaV7lmCubZP5+/FKHz3iNvtvFuJnGUkl7jNEq7W8lDpP 1254054511
Date: Sun, 27 Sep 2009 09:28:28 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Ingo Molnar <mingo@elte.hu>
Cc: Len Brown <lenb@hera.kernel.org>, torvalds@linux-foundation.org,
       akpm@linux-foundation.org, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [origin tree build failure] [PATCH] thinkpad-acpi: Fix build
 on !CONFIG_THINKPAD_ACPI_HOTKEY_POLL
Message-ID: <20090927122828.GA24783@khazad-dum.debian.net>
References: <200909260519.n8Q5JrB6016778@hera.kernel.org>
 <20090927075254.GA20847@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090927075254.GA20847@elte.hu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 27 Sep 2009, Ingo Molnar wrote:
> >  drivers/platform/x86/thinkpad_acpi.c    |  632 +++++++++++++++++++---------
> 
> -tip testing found that these changes caused a build failure 
> in drivers/platform/x86/thinkpad_acpi.c when 
> !CONFIG_THINKPAD_ACPI_HOTKEY_POLL - the fix is attached 
> below.

Fixed by a different patch, which will hit mainline soon.  Len already
merged the fix in acpi-test.

BTW, the function _is_ used even when CONFIG_THINKPAD_ACPI_HOTKEY_POLL is
undefined...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
