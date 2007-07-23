Return-Path: <linux-kernel-owner+w=401wt.eu-S933038AbXGWAQm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933038AbXGWAQm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jul 2007 20:16:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761148AbXGWAQf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 22 Jul 2007 20:16:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.178]:7006 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759535AbXGWAQe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jul 2007 20:16:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=nGjx5IAXJ70a77wl4knaiERmROClYk680EdUCUiMBOqVjFv8tBdEsevHpjaLQ+F6/lSU3SGJJCSlFUwiE/z7KAT1qcMQldrcLcZobnHYLIm/fTK64BSy3LGnPylKxpgAaBdsKiwUsA15xH/+grQ6or//j3jDGtp1MKyVuNP8w9w=
Message-ID: <6bffcb0e0707221716k67815a2ai7f35606b1effa6a3@mail.gmail.com>
Date: Mon, 23 Jul 2007 02:16:33 +0200
From: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
To: "Ni@m" <niam.niam@gmail.com>
Subject: Re: sound is interrupting with new kernels
Cc: LKML <linux-kernel@vger.kernel.org>, "Ingo Molnar" <mingo@elte.hu>
In-Reply-To: <a9e22dff0707211510o3b5e108dk354f5f15ad3ba498@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a9e22dff0707211510o3b5e108dk354f5f15ad3ba498@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 22/07/07, Ni@m <niam.niam@gmail.com> wrote:
> Hi to all!
> I have a problem with recent 2.6.22 kernel with cfs-19 patch.
> While I'm watching the video using mplayer or listening to the music
> using audacious the sound is interrupting rather often.
>
> During I'm watching the video I don't really doing something heavy
> with my computer. Besides ... when I try to renice mplayer to make it
> priority higher[I mean lower with renice syntax 8) - renice -20 `pidof
> mplayer`] - it helps for _some_time_.
>
> my uname -a:
> "Linux niam 2.6.22-cfs-v19 #3 Sat Jul 14 14:15:57 EEST 2007 i686
> Intel(R) Celeron(R) M processor 1.50GHz GenuineIntel GNU/Linux"
>
> I've attached .config of my kernel and output of `ps aux`. With this
> tasks state my audio player interrupting ...
>
> Thank you for your time and your help!

Please run this script while using mplayer or audacious
http://people.redhat.com/mingo/cfs-scheduler/tools/cfs-debug-info.sh
and send results

Ingo, this might be a regression.

Regards,
Michal

-- 
LOG
http://www.stardust.webpages.pl/log/
