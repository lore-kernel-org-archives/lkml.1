Return-Path: <linux-kernel-owner+w=401wt.eu-S1752099AbZLIR1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752099AbZLIR1r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 12:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750936AbZLIR1p
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 12:27:45 -0500
Received: from mail1.slb.deg.dub.stisp.net ([84.203.253.98]:3003 "HELO
	mail1.slb.deg.dub.stisp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750924AbZLIR1p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 12:27:45 -0500
Message-ID: <4B1FDDE2.1090507@draigBrady.com>
Date: Wed, 09 Dec 2009 17:26:58 +0000
From: =?ISO-8859-1?Q?P=E1draig_Brady?= <P@draigBrady.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091204 Thunderbird/3.0
MIME-Version: 1.0
To: Cypher Wu <cypher.w@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: Questions about Watch Dog Timer under Linux.
References: <f9f38a550912090647q5af6cb14w84ea8d9223d82bd9@mail.gmail.com>
In-Reply-To: <f9f38a550912090647q5af6cb14w84ea8d9223d82bd9@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/09 14:47, Cypher Wu wrote:
> I'm used to work on embedded systems, the Watch Dog Timer in our
> products is usually a seperate chip on the board wich will start to
> work after power reset and will time out in 2 seconds. The system has
> to start dog clearing from the very beginning and there have no way to
> disable WDT.

wow 2 seconds :(

It's easy to patch grub stage 1 to pat the watchdog.
I was even able to get support for the complicated iTCO intel
watchdogs in there, though your watchdog may be much simpler.

Then when the kernel started it patted the watchdog as normal.

Note I did this to support robust remote upgrade (as the boot
loader wasn't touched on upgrade), rather than to support a
very short timeout.

cheers,
Pádraig.
