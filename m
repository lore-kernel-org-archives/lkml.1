Return-Path: <linux-kernel-owner+w=401wt.eu-S934614AbZJJAJQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934614AbZJJAJQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Oct 2009 20:09:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758881AbZJJAJP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Oct 2009 20:09:15 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:57562 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757322AbZJJAJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Oct 2009 20:09:14 -0400
X-Sasl-enc: 0HEjKSeWxOXHqfMxbncY3AgiFfLvwq7pEZfp4qvORPIM 1255133291
Date: Fri, 9 Oct 2009 21:08:08 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Randy Dunlap <randy.dunlap@oracle.com>, Ingo Molnar <mingo@elte.hu>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, lenb@kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -next] thinkpad_acpi: fix build, HOTKEY_POLL is optional
Message-ID: <20091010000808.GA10637@khazad-dum.debian.net>
References: <20091009190654.741eeffd.sfr@canb.auug.org.au>
 <20091009161723.b68b91a7.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20091009161723.b68b91a7.randy.dunlap@oracle.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 09 Oct 2009, Randy Dunlap wrote:
> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix optional part of driver to be built optionally:

NAK!

This happens because of (linux-next) commit
7f6443f7238a0aa9014b11a0a31ab76825d75cdf 
"thinkpad-acpi: Fix build on !CONFIG_THINKPAD_ACPI_HOTKEY_POLL" by
Ingo.

That commit is wrong, it must NOT be applied as explained in the thread
starting at http://lkml.org/lkml/2009/9/27/30.

Ingo, can you please check if you don't have that commit still in one of
your trees that are fed into linux-next?  It broke the driver now that the
"backlight/thinkpad-acpi: issue backlight class events" patch landed in
-next, just like I said it would happen...

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
