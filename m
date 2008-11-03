Return-Path: <linux-kernel-owner+w=401wt.eu-S1756001AbYKCOQn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756001AbYKCOQn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 09:16:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754236AbYKCOQe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 09:16:34 -0500
Received: from out5.smtp.messagingengine.com ([66.111.4.29]:55711 "EHLO
	out5.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752786AbYKCOQd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 09:16:33 -0500
X-Sasl-enc: 08YPT/EEPp/wdwzoy3LV00m6dyytibJo5mKMiUqud2O8 1225721791
Date: Mon, 3 Nov 2008 12:16:28 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       linux acpi <linux-acpi@vger.kernel.org>
Subject: Re: eeepc-laptop rfkill, stupid question #4
Message-ID: <20081103141628.GB31078@khazad-dum.debian.net>
References: <490B3BB5.8060801@tuffmail.co.uk> <20081031171126.GA17313@srcf.ucam.org> <490B4014.4040009@tuffmail.co.uk> <490B70A3.8010108@tuffmail.co.uk> <20081102040008.GB29606@khazad-dum.debian.net> <490D8C4E.3010201@tuffmail.co.uk> <20081102130655.GA12766@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081102130655.GA12766@srcf.ucam.org>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
	1CDB 0FE3
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 02 Nov 2008, Matthew Garrett wrote:
> resume path. However, as you point out, right now it's possible for the 
> user to change the hardware state in the BIOS and cause the two to get 
> out of sync. That's certainly not ideal.

In fact, it is a bug.

Can you read the state?  If so, you need to unconditionally do so on resume
(from sleep or hibernation) and rfkill_force_state() it.

If you CANNOT read the state, you will have to force the radio to a known
state somehow.

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
