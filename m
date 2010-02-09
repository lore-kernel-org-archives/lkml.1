Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752525Ab0BIAi5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 19:38:57 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:46967 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752018Ab0BIAi4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 19:38:56 -0500
X-Sasl-enc: EE9M/YTKnuaFu/gFmlo3NbjUtr9rwyMPdNs+5nHrbZZZ 1265675935
Date: Mon, 8 Feb 2010 22:38:53 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-acpi@vger.kernel.org,
       Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
       ibm-acpi-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] thinkpad-acpi: setup hotkey polling after changing
 hotkey_driver_mask
Message-ID: <20100209003853.GD21680@khazad-dum.debian.net>
References: <1265567528-1180-1-git-send-email-cascardo@holoscopio.com>
 <20100208155059.eed393a6.akpm@linux-foundation.org>
 <20100209000810.GC1420@holoscopio.com>
 <20100208162153.b317e434.akpm@linux-foundation.org>
 <20100209003131.GE1420@holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100209003131.GE1420@holoscopio.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 08 Feb 2010, Thadeu Lima de Souza Cascardo wrote:
> You've fixed the hotkey_poll_setup to a hotkey_poll_setup_safe that has
> just been added by a patch of mine to the function brightness_init. The
> same has not been done to the call that has been added to the function
> volume_init.

Andrew said it didn't matter for the __init functions in thinkpad-acpi, and
he is correct.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
