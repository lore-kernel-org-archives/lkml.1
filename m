Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755067Ab0BJB21 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Feb 2010 20:28:27 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:50159 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754944Ab0BJB20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Feb 2010 20:28:26 -0500
X-Sasl-enc: JSe+yb/lYIwzRix5DYKF/WTLWgMyLX68lDsOCwEDa54H 1265765305
Date: Tue, 9 Feb 2010 23:28:22 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Cc: linux-acpi@vger.kernel.org, ibm-acpi-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] thinkpad-acpi: setup hotkey polling after changing
 hotkey_driver_mask
Message-ID: <20100210012821.GA7710@khazad-dum.debian.net>
References: <1265567528-1180-1-git-send-email-cascardo@holoscopio.com>
 <20100209003706.GC21680@khazad-dum.debian.net>
 <20100209013736.GE21680@khazad-dum.debian.net>
 <20100210001651.GA1422@holoscopio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100210001651.GA1422@holoscopio.com>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Feb 2010, Thadeu Lima de Souza Cascardo wrote:
> Sorry for the delay. Takes a while to build a kernel in my old notebook
> with a not-so-large config.

Heh, I know how you feel.  Maybe you can use distcc to offload the worst of
the work to a more powerful box?

> It works nice for me. This was a fix that has crossed my mind, but since
> other init was doing the other way (hotkey_init), I did prefer that too.
> Anyway, your way is cleaner and the right way.  :-)

hotkey_* kinda "owns" the event interface, so it is allowed some liberties I
try to avoid in the other parts of the driver :)

> Tested-by: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>

Thank you.  I will forward it to Len.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
