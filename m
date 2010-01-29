Return-Path: <linux-kernel-owner+w=401wt.eu-S1756088Ab0A2W7X@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756088Ab0A2W7X (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 17:59:23 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755992Ab0A2W7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 17:59:22 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:56260 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755966Ab0A2W7V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 17:59:21 -0500
X-Sasl-enc: kCUXvOOazarISVbPQ+h0TiYbS9fzawu1T7LcXIqkXJNR 1264805961
Date: Fri, 29 Jan 2010 20:59:16 -0200
From: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
To: =?iso-8859-1?Q?J=2EA=2E_Magall=F3n?= <jamagallon@ono.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Hyperthreading on Core i7s: To use or not to use?
Message-ID: <20100129225916.GC19420@khazad-dum.debian.net>
References: <6278d2221001260256q5f35457fye8baabcc333d40@mail.gmail.com>
 <20100127015018.42793269@werewolf.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100127015018.42793269@werewolf.home>
X-GPG-Fingerprint: 1024D/1CDB0FE3 5422 5C61 F6B7 06FB 7E04  3738 EE25 DE3F
 1CDB 0FE3
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jan 2010, J.A. Magallón wrote:
> On Tue, 26 Jan 2010 10:56:57 +0000, Daniel J Blueman <daniel.blueman@gmail.com> wrote:
> Well, with that i7 you have:
> - 1 processor
> - 4 cores
> - 8 threads (4x2)

And Turbo Boost, let's not forget it.

> What does 'within the noise' mean for you ?
> With the 4-on mode, it just takes 2x the time to do the work...(look at elapsed!)
> So, assuming the kernel is 'intelligent':
> - Using 4 threads, it takes 17.44, and scheduler is using 4 threads located
>   on different cores.
> - Using 8 threads, it takes  9.50. So effciency is 17.44/(2*9.50) = 91%
>   Very good! So this HyperThreading is not like that old in P4s, works much
>   better. Even with each couple threads competing for registers and L1 (or L2?)
>   cache.
> 
> So hyper threading is good, why should you disable it ?

When for some reason it gives you less 'automatic overclocking' and your
workload happens to benefit more from less cores with a higher clock, than
more cores with a lower clock, I suppose.

Which might just mean one in that situation should try the 'power aware
scheduler' since it supposedly tries to idle threads/cores a lot more, which
should make it easier for the active cores to overclock themselves.

Using Len's userspace utility to track the real freq. of boosted cores might
give some insights.  It is in his pmtools package, available at:
http://ftp.kernel.org/pub/linux/kernel/people/lenb/acpi/utils/

-- 
  "One disk to rule them all, One disk to find them. One disk to bring
  them all and in the darkness grind them. In the Land of Redmond
  where the shadows lie." -- The Silicon Valley Tarot
  Henrique Holschuh
