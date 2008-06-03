Return-Path: <linux-kernel-owner+w=401wt.eu-S1756767AbYFCXvR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756767AbYFCXvR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jun 2008 19:51:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752983AbYFCXvE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 3 Jun 2008 19:51:04 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55512 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752796AbYFCXvB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jun 2008 19:51:01 -0400
Date: Tue, 3 Jun 2008 16:48:30 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: avorontsov@ru.mvista.com
Cc: galak@kernel.crashing.org, wim@iguana.be, jochen@scram.de,
       sfr@canb.auug.org.au, segher@kernel.crashing.org,
       scottwood@freescale.com, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8 v4] mpc83xx_wdt rework, support for mpc8610 and
 mpc8xx
Message-Id: <20080603164830.32457962.akpm@linux-foundation.org>
In-Reply-To: <20080602173726.GA24556@polina.dev.rtsoft.ru>
References: <20080602173726.GA24556@polina.dev.rtsoft.ru>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Jun 2008 21:37:26 +0400
Anton Vorontsov <avorontsov@ru.mvista.com> wrote:

> No comments on the previous version for two weeks... resending once
> again.

I did all the rework to make the patches apply on top of all the
pending watchdog work in Wim's tree and in -mm.  I haven't build tested
it yet.


I'll assume that

 [PATCH 7/8] [POWERPC] fsl_soc: remove mpc83xx_wdt code

and

 [PATCH 8/8] [POWERPC] 86xx: mpc8610_hpcd: add watchdog node

are dependent upon the preceding six patches.  This might be wrong.


Please put the subsystem identifier (eg, "watchdog" and "powerpc")
outside the [], for reasons which should be in
Documentation/SubmittingPatches, which used to be there but which got
lost.  Bascially the text inside [] is for temporary not-for-committing
information such as "rfc", "2.6.24-rc4", "resend", etc and should be stripped
by the email recipient before merging.


