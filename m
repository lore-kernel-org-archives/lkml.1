Return-Path: <linux-kernel-owner+w=401wt.eu-S1756127AbYBRO1i@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127AbYBRO1i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2008 09:27:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752102AbYBRO11
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 18 Feb 2008 09:27:27 -0500
Received: from ns2.suse.de ([195.135.220.15]:49471 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751824AbYBRO10 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2008 09:27:26 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [patch 2/2] x86: lds - Use THREAD_SIZE instead of =?iso-8859-1?q?numeric=09constant?=
Date: Mon, 18 Feb 2008 15:27:22 +0100
User-Agent: KMail/1.9.6
Cc: Cyrill Gorcunov <gorcunov@gmail.com>, Sam Ravnborg <sam@ravnborg.org>,
       mingo@elte.hu, tglx@linutronix.de, linux-kernel@vger.kernel.org
References: <20080217151716.274134094@gmail.com> <20080217200654.GF31968@cvg> <47B89501.5090108@zytor.com>
In-Reply-To: <47B89501.5090108@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802181527.22502.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> You're saying that it *must* be aligned, I don't think that's true 
> anymore; I think nowadays it's more accurate to say that it *is* 
> aligned, but I don't think that's fundamental.

At least in .25 mainline current_thread_info() is still using
[re]sp arithmetic.  Also I think the stack backtracers also
rely on suitable alignment of the stack top. So right now it is still 
fundamental. Now that could be all fixed by using segment
register references and might be, but so far that doesn't
seem to be finished yet.


-Andi
