Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934429Ab0CLSSi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Mar 2010 13:18:38 -0500
Received: from ist.d-labs.de ([213.239.218.44]:42480 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934212Ab0CLSSh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Mar 2010 13:18:37 -0500
Date: Fri, 12 Mar 2010 19:18:19 +0100
From: Florian Mickler <florian@mickler.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Marcel Holtmann" <marcel@holtmann.org>,
       "Henrique de Moraes Holschuh" <hmh@hmh.eng.br>,
       "Johannes Berg" <johannes@sipsolutions.net>,
       linux-wireless@vger.kernel.org, "Randy Dunlap" <rdunlap@xenotime.net>,
       "Alan Jenkins" <alan-jenkins@tuffmail.co.uk>,
       linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH 0/2]  rfkill sysfs ABI
Message-ID: <20100312191819.73ac4700@schatten.dmk.lab>
In-Reply-To: <1268416988-24862-1-git-send-email-florian@mickler.org>
References: <1268416988-24862-1-git-send-email-florian@mickler.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.16.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Mar 2010 19:03:06 +0100
florian@mickler.org wrote:

> Hi all!
> 
> The first patch moves the rfkill sysfs ABI Documentation to Documentation/ABI
> and deprecates the state and claim file. 
> 
> The second patch creates a replacement for the state file. Instead of exporting
> some made-up state we just export the state of the 2 kill lines. 
> 
> The first patch should probably go into 2.6.34, as to warn users 
> (if there are any) early about this removal. 
> If there is no intent to remove the broken files, the feature-removal-schedule hunk 
> should probably be skipped. 
> 
> Cheers,
> Flo
> 
> p.s.: first discussion of this: http://lkml.org/lkml/2010/2/22/127
> 

Hi,

sorry! I just realised that you already have the blocked_sw / blocked_hw one's
queued. 

This just changes the name of blocked_sw and blocked_hw to "soft" and
"hard". 

I don't know what you wanna do. I'm fine with blocked_hw and
blocked_sw as it's referenced as such (hw/sw) in the code, but Marcel
wanted to get away from the "hard blocked by hardware" notation, as it
suggests that the transmitter could only be blocked by hardware...

cheers,
Flo
