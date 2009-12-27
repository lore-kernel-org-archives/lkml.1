Return-Path: <linux-kernel-owner+w=401wt.eu-S1752198AbZL0PRy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbZL0PRy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Dec 2009 10:17:54 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751881AbZL0PRx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Dec 2009 10:17:53 -0500
Received: from hiauly1.hia.nrc.ca ([132.246.100.193]:3816 "EHLO
	hiauly1.hia.nrc.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751875AbZL0PRx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Dec 2009 10:17:53 -0500
X-Greylist: delayed 420 seconds by postgrey-1.27 at vger.kernel.org; Sun, 27 Dec 2009 10:17:53 EST
Subject: Re: [PATCH] parisc: test off by one in sgl_frem() and dbl_frem()
To: roel.kluin@gmail.com (Roel Kluin)
Date: Sun, 27 Dec 2009 10:10:45 -0500 (EST)
From: "John David Anglin" <dave@hiauly1.hia.nrc.ca>
Cc: kyle@mcmartin.ca, deller@gmx.de, jejb@parisc-linux.org,
       linux-parisc@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <4B375F68.80301@gmail.com> from "Roel Kluin" at Dec 27, 2009 02:21:44 pm
X-Mailer: ELM [version 2.4 PL25]
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-Id: <20091227151047.15BE74EB5@hiauly1.hia.nrc.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> With `while (stepcount-- > 0)' stepcount reaches -1 after the loop.
> 
> Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
> ---
>  arch/parisc/math-emu/dfrem.c |    2 +-
>  arch/parisc/math-emu/sfrem.c |    2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> Unless I am missing something?

Are you sure the correct fix isn't to move the decrement of stepcount
into the loop?

Dave
-- 
J. David Anglin                                  dave.anglin@nrc-cnrc.gc.ca
National Research Council of Canada              (613) 990-0752 (FAX: 952-6602)
