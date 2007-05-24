Return-Path: <linux-kernel-owner+w=401wt.eu-S1753627AbXEXWIc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753627AbXEXWIc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 18:08:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751609AbXEXWIX
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 18:08:23 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:33603 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751165AbXEXWIW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 18:08:22 -0400
X-Sasl-enc: JYvDKdXM1acAkSwTTHT7zbhf+jcDSHVZGFWYjC0WNvUw 1180044500
Date: Thu, 24 May 2007 19:08:16 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, linux-acpi@vger.kernel.org
Subject: Re: [BUG] long freezes on thinkpad t60
Message-ID: <20070524220816.GC23214@khazad-dum.debian.net>
References: <E1HrC3W-0005SZ-00@dorka.pomaz.szeredi.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1HrC3W-0005SZ-00@dorka.pomaz.szeredi.hu>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F 1CDB 0FE3
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 May 2007, Miklos Szeredi wrote:
> Tried nmi_watchdog=1, but then the machine locks up hard shortly after
> boot.

NMIs in some thinkpads are bad trouble, they lock up the blasted IBM/Lenovo
SMBIOS if they happen to hit it while it is servicing a SMI, and thinkpads
do SMIs like crazy.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
