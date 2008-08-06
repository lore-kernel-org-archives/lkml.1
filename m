Return-Path: <linux-kernel-owner+w=401wt.eu-S1753994AbYHFMuv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994AbYHFMuv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Aug 2008 08:50:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753051AbYHFMpx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Aug 2008 08:45:53 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:42589 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752749AbYHFMps (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Aug 2008 08:45:48 -0400
X-Sasl-enc: XgwIfH1MXkV80O65ILmNEZUOnXg44hVIC3JOttJirr62 1218026745
Date: Wed, 6 Aug 2008 09:45:42 -0300
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Philip Langdale <philipl@overt.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Matthew Garrett <mjg59@srcf.ucam.org>,
       toshiba_acpi@memebeam.org, Ivo van Doorn <ivdoorn@gmail.com>,
       linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/1] toshiba_acpi: Add support for bluetooth toggling
	through rfkill (v2)
Message-ID: <20080806124542.GD12783@khazad-dum.debian.net>
References: <4894B1B4.6050003@overt.org> <20080803042613.GC6053@khazad-dum.debian.net> <48965716.6020508@overt.org> <20080805212416.GB21738@khazad-dum.debian.net> <48991B83.5030607@overt.org> <20080806122642.GA12783@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080806122642.GA12783@khazad-dum.debian.net>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 06 Aug 2008, Henrique de Moraes Holschuh wrote:
> Some network drivers want to do it themselves, so now it will be the job of
> every driver to know whether it should do something or not.
> 
> To test your platform to know if you will need to do something, just comment
> the rfkill->toggle_radio in rfkill_suspend, and check if your radios are
> still transmitting when you suspend.  I really doubt any laptop has that
> problem, though.

Oh, and if you don't have a way to test, you can just call your own private
switch_my_radios_off() function in your driver's suspend() handler.  You
don't even have to turn them back on on resume(), as rfkill will always do
that for you.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
