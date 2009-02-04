Return-Path: <linux-kernel-owner+w=401wt.eu-S1758565AbZBDXkl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758565AbZBDXkl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 18:40:41 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754516AbZBDXkZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 18:40:25 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44510 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753962AbZBDXkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 18:40:23 -0500
Date: Wed, 4 Feb 2009 15:39:54 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Alex Romosan <romosan@sycorax.lbl.gov>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.29-rc3: weird process after resume
Message-Id: <20090204153954.844ac67b.akpm@linux-foundation.org>
In-Reply-To: <878womf727.fsf@sycorax.lbl.gov>
References: <878womf727.fsf@sycorax.lbl.gov>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Feb 2009 09:25:20 -0800
Alex Romosan <romosan@sycorax.lbl.gov> wrote:

> this is on a thinkpad t61p with an intel core2 cpu. i just noticed
> that after resuming from suspending to memory i get a weirdly named
> process. i did a ps before and after and the only difference was that
> before i had this process:
> 
>   [hda0/1]
> 
> and after this one:
> 
>   [__?__;??____D__"?______]
> 
> with everything else being the same. the laptop seems to be working
> fine and the problem could have been there for a while but i just
> didn't notice it. i am including my .config file. let me know if you
> need anything else.

Were earlier kernels OK?  If so, which version?

What the heck is that kernel thread anyway?  It looks like something
derived from an IDE device.
