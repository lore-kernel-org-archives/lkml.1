Return-Path: <linux-kernel-owner+w=401wt.eu-S1754793AbYGBS0M@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754793AbYGBS0M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2008 14:26:12 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752185AbYGBSZ6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 2 Jul 2008 14:25:58 -0400
Received: from door1.ift.unesp.br ([200.145.46.252]:49215 "EHLO
	mail.ift.unesp.br" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751950AbYGBSZ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2008 14:25:57 -0400
Date: Wed, 2 Jul 2008 15:23:04 -0300
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: sfr@canb.auug.org.au
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu
Subject: Re: linux-next boot failure on 64-bit Sony Vaio (maybe x86 related)
Message-ID: <20080702182304.GA5252@beyonder.ift.unesp.br>
Mail-Followup-To: sfr@canb.auug.org.au, linux-kernel@vger.kernel.org,
	mingo@elte.hu
References: <20080702141556.GA25441@beyonder.ift.unesp.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080702141556.GA25441@beyonder.ift.unesp.br>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> I could not bisect this problem yet because the first linux-next
> which I tried to use was next-20080618 which had a similar boot
> failure, that time at kernel/smp.c:215
> http://www.ift.unesp.br/users/crmafra/failed_boot0.jpg

Ok, I spent some time compiling and found out that

-next-20080424 is good
-next-20080428 is bad

and all kernels after 20080428 that I've tried failed to boot.

The problem with 20080428 is a NULL pointer dereference:
http://www.ift.unesp.br/users/crmafra/img_2436.jpg

and this is apparently the same error as current 20080702 when
booted with the 'nosmp' parameter:
http://www.ift.unesp.br/users/crmafra/img_2425.jpg

The sad thing is that these are the last messages on the screen,
but there were others before them (I think that's why it says
it is tainted).
