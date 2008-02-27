Return-Path: <linux-kernel-owner+w=401wt.eu-S1754753AbYB0LGz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753AbYB0LGz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Feb 2008 06:06:55 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751691AbYB0LGp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Feb 2008 06:06:45 -0500
Received: from smtp4.int-evry.fr ([157.159.10.71]:55612 "EHLO
	smtp4.int-evry.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888AbYB0LGo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Feb 2008 06:06:44 -0500
From: Florian Fainelli <florian.fainelli@telecomint.eu>
To: Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH] [x86] rdc321x: Kconfig options fixes for rdc321x
Date: Wed, 27 Feb 2008 12:06:43 +0100
User-Agent: KMail/1.9.7
Cc: linux-kernel@vger.kernel.org
References: <200802271136.42763.florian.fainelli@telecomint.eu> <20080227105307.GA21050@elte.hu>
In-Reply-To: <20080227105307.GA21050@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200802271206.44493.florian.fainelli@telecomint.eu>
X-int-MailScanner-Information: Please contact the ISP for more information
X-int-MailScanner: Found to be clean
X-int-MailScanner-SpamCheck: 
X-int-MailScanner-From: florian.fainelli@telecomint.eu
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

Le mercredi 27 février 2008, Ingo Molnar a écrit :
> these many special conditions in the Kconfig space are way too ugly.
> (Also, i can see no reason why for example hibernation wouldnt be
> possible on rdc321x, it's a pure software concept ...)

I would have thought an embedded device with only flash memory as rom storage 
could not hibertnate.

Maybe we should turn all those special conditions into HAVE_FOO/BAR instead ?
