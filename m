Return-Path: <linux-kernel-owner+w=401wt.eu-S1753031AbYFOTO5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753031AbYFOTO5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2008 15:14:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750933AbYFOTOp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 15 Jun 2008 15:14:45 -0400
Received: from server009.webpack.hosteurope.de ([80.237.130.17]:54830 "EHLO
	server009.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750915AbYFOTOn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2008 15:14:43 -0400
From: Daniel Exner <dex@dragonslave.de>
Reply-To: webmaster@dragonslave.de
To: "Yinghai Lu" <yhlu.kernel@gmail.com>
Subject: Re: linux-next Regression: Unable to locate IOAPIC
Date: Sun, 15 Jun 2008 21:14:32 +0200
User-Agent: KMail/1.9.9
Cc: "Alexey Starikovskiy" <aystarik@gmail.com>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, linux-next@vger.kernel.org,
       linux-acpi@vger.kernel.org, "Ingo Molnar" <mingo@elte.hu>
References: <200806051100.12885.dex@dragonslave.de> <48536E3B.4000703@gmail.com> <86802c440806140126l7a949783of0fb08d11ae07bef@mail.gmail.com>
In-Reply-To: <86802c440806140126l7a949783of0fb08d11ae07bef@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200806152114.33007.dex@dragonslave.de>
X-bounce-key: webpack.hosteurope.de;dex@dragonslave.de;1213557283;1f656645;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Yinghai Lu wrote:
> >> To clarify myself:
> >> 2.6.25.5:  --> relatively fast no IOAPIC Errors in dmesg
> >> 2.6.26-rc5:   --> relatively  no IOAPIC Errors in dmesg
> >> 2.6.26-rc5 + git-acpi Patch:   --> relatively  no IOAPIC Errors in dmesg
> >> 2.6.26-rc5 +  linux-next snapshot 20080604 --> even slower than before
> >> my ide Patch many "unable to locate IOAPIC" Errors
> >>
> >>
> >> So I think the problem lies not in the acpi tree but somewhre else.
> >>
> >> Is it possible to tell git to explicitly _exclude_ a specific tree while
> >> bisecting?
>
> can you check if the attached patch fix the problem?
> it will not check entries before MP_intsrc_info...
This fixed it, thanks :)

Also maschine feels not as fast as with 2.6.25.x but noticeable faster :)

I guss you no longer need the complete dmesg output?

Greetings
Daniel Exner
