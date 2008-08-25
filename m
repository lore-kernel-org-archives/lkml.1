Return-Path: <linux-kernel-owner+w=401wt.eu-S1755255AbYHYAOW@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255AbYHYAOW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2008 20:14:22 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752948AbYHYAOG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 24 Aug 2008 20:14:06 -0400
Received: from ozlabs.org ([203.10.76.45]:44758 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752412AbYHYAOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2008 20:14:05 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: CONFIG_KMOD breakage in next kernel
Date: Mon, 25 Aug 2008 10:13:58 +1000
User-Agent: KMail/1.9.9
Cc: Takashi Iwai <tiwai@suse.de>, linux-next@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Stephen Rothwell <sfr@canb.auug.org.au>,
       LKML <linux-kernel@vger.kernel.org>, netdev@vger.kernel.org,
       video4linux-list@redhat.com
References: <s5h3akzwtki.wl%tiwai@suse.de> <1219256165.3502.10.camel@johannes.berg>
In-Reply-To: <1219256165.3502.10.camel@johannes.berg>
MIME-Version: 1.0
Content-Disposition: inline
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200808251013.58975.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 August 2008 04:16:05 Johannes Berg wrote:
> Hi,
>
> > I found that CONFIG_KMOD was already removed in linux-next tree.
> > This seems to result in many breakages.  For example, I cannot mount a
> > FAT device automatically because of failure of automatic loading of
> > nls modules.
>
> This is odd. I had posted a long series of patches removing all of the
> users I had found (similar grep like the one you used), see
> http://lkml.org/lkml/2008/7/9/150 for the whole thread.
>
>
> For some reason, only seven of those eleven patches ended up in the
> kernel, you had taken the alsa one and Rusty posted only six of them.

OK, not quite sure what happened.  I'll grab the rest and push them into 
tomorrow's linux-next.

For today, I'll pull out the CONFIG_KMOD removal.

Thanks,
Rusty.
