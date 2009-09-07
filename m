Return-Path: <linux-kernel-owner+w=401wt.eu-S1752689AbZIGV5P@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752689AbZIGV5P (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Sep 2009 17:57:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752375AbZIGV5P
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 7 Sep 2009 17:57:15 -0400
Received: from out1.smtp.messagingengine.com ([66.111.4.25]:43279 "EHLO
	out1.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751072AbZIGV5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Sep 2009 17:57:14 -0400
X-Sasl-enc: T6+ZENo7VXnVpoOIizD3ZH2NLqPNm+DCmc6wmazLL4kh 1252360636
Date: Mon, 7 Sep 2009 18:57:12 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Karol Lewandowski <karol.k.lewandowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, astarikovskiy@suse.de, lenb@kernel.org,
       linux-acpi@vger.kernel.org, rjwysocki@sisk.pl
Subject: Re: [PATCH] Fix ACPI's EC regression from 2.6.29: use usleep()
 instead of msleep()
Message-ID: <20090907215712.GH16533@khazad-dum.debian.net>
References: <20090907211423.GA2535@bizet.domek.prywatny>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090907211423.GA2535@bizet.domek.prywatny>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 07 Sep 2009, Karol Lewandowski wrote:
> Following patch reverts commit that changed usleep() to mleep()
> in ACPI's EC driver. That change made hotkeys on my Thinkpad T21
> unusable after resume.

Karol, can you send us the dmidecode information for your thinkpad?

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
