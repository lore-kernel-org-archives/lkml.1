Return-Path: <linux-kernel-owner+w=401wt.eu-S1754751AbZKCTda@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754751AbZKCTda (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Nov 2009 14:33:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754309AbZKCTda
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Nov 2009 14:33:30 -0500
Received: from smtp240.poczta.interia.pl ([217.74.64.240]:39022 "EHLO
	smtp240.poczta.interia.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbZKCTd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Nov 2009 14:33:29 -0500
Date: Tue, 3 Nov 2009 20:51:18 +0100
From: Krzysztof Helt <krzysztof.h1@poczta.fm>
To: Dave Jones <davej@redhat.com>
Cc: cpufreq@vger.kernel.org, LKLM <linux-kernel@vger.kernel.org>,
       Rafal Bilski <rafalbilski@interia.pl>
Subject: Re: [PATCH] longhaul: select Longhaul version 2 for capable CPUs
Message-Id: <20091103205118.607df52b.krzysztof.h1@poczta.fm>
In-Reply-To: <20091025032813.GB2475@redhat.com>
References: <20091024172538.e2c8776b.krzysztof.h1@poczta.fm>
	<20091025032813.GB2475@redhat.com>
X-Mailer: Sylpheed 2.4.3 (GTK+ 2.11.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-EMID: 90e2b138
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 24 Oct 2009 23:28:14 -0400
Dave Jones <davej@redhat.com> wrote:

> On Sat, Oct 24, 2009 at 05:25:38PM +0200, Krzysztof Helt wrote:
>  > From: Krzysztof Helt <krzysztof.h1@wp.pl>
>  > 
>  > There is a typo in the longhaul detection code so only Longhaul v1 or Longhaul v3
>  > is selected. The Longhaul v2 is not selected even for CPUs which are capable of.
>  > 
>  > Tested on PCChips Giga Pro board. Frequency changes work and the Longhaul v2
>  > detects that the board is not capable of changing CPU voltage.
>  > 
>  > Signed-off-by: Krzysztof Helt <krzysztof.h1@wp.pl>
>  
> It seems we deliberately changed this two years ago, though the changelog
> is a bit sparse on details..
> 
> commit 07844252ffd81ec192a62014bada1016c9703765
> Author: Rafal Bilski <rafalbilski@interia.pl>
> Date:   Sun Apr 22 12:26:04 2007 +0200
> 
>     [CPUFREQ] Longhaul - Revert Longhaul ver. 2
>     
>     There is something wrong with this code. It needs more
>     testing. It is better to disable it for now because support
>     for some machines will be broken.
>     
>     Signed-off-by: Rafal Bilski <rafalbilski@interia.pl>
>     Signed-off-by: Dave Jones <davej@redhat.com>
> 
> 

Are there any chances this patch will go into the linux-next?

Regards,
Krzysztof

------------------------------------------------------------------------------
Strrraszny konkurs z Scooby-Doo!
Wez udzial >> http://link.interia.pl/f2412

