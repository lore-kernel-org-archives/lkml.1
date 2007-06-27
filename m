Return-Path: <linux-kernel-owner+w=401wt.eu-S1758892AbXF0SOI@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758892AbXF0SOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2007 14:14:08 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752655AbXF0SN6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 Jun 2007 14:13:58 -0400
Received: from x35.xmailserver.org ([64.71.152.41]:1288 "EHLO
	x35.xmailserver.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263AbXF0SN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2007 14:13:57 -0400
X-AuthUser: davidel@xmailserver.org
Date: Wed, 27 Jun 2007 11:13:52 -0700 (PDT)
From: Davide Libenzi <davidel@xmailserver.org>
X-X-Sender: davide@alien.or.mcafeemobile.com
To: Hugh Dickins <hugh@veritas.com>
cc: Ulrich Drepper <drepper@gmail.com>, blaisorblade@yahoo.it,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [patch 2/3] MAP_NOZERO - implement sys_brk2()
In-Reply-To: <Pine.LNX.4.64.0706271807330.22337@blonde.wat.veritas.com>
Message-ID: <Pine.LNX.4.64.0706271111040.32731@alien.or.mcafeemobile.com>
References: <send-serie.davidel@xmailserver.org.29496.1182912260.2> 
 <a36005b50706262048y5eb8ba80kb0d852d649d1ac10@mail.gmail.com> 
 <Pine.LNX.4.64.0706262052060.26540@alien.or.mcafeemobile.com> 
 <a36005b50706262202w4aaa4494qc2322e49c71d8d7c@mail.gmail.com> 
 <Pine.LNX.4.64.0706271309500.26951@blonde.wat.veritas.com>
 <a36005b50706271001o191f3e24n83b25988739429fb@mail.gmail.com>
 <Pine.LNX.4.64.0706271807330.22337@blonde.wat.veritas.com>
X-GPG-FINGRPRINT: CFAE 5BEE FD36 F65E E640  56FE 0974 BF23 270F 474E
X-GPG-PUBLIC_KEY: http://www.xmailserver.org/davidel.asc
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Jun 2007, Hugh Dickins wrote:

> In honesty, I should add that I dislike and distrust Davide's
> MAP_NOZERO very much indeed!  Would much rather leave my cpus
> spending a little time in clear_page().  A uid in struct page
> (though I'm sure we could find somewhere to tuck it away) -
> the horror, the horror!  But I've so far failed to find a killer
> argument against it, and am hoping for someone else to do so.

Little time? Please, do not trust me. Start oprofile and run a kernel 
build. Look, I'm not even talking about som micro benchmark explicitly 
built to exploit the thing. A kernel build.
You will find clear_page to be the *1st* kernel entry after cc1 and as.
That is bad for two reasons. The time it spends in there, and the cache it 
blows.



- Davide


