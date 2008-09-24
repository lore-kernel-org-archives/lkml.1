Return-Path: <linux-kernel-owner+w=401wt.eu-S1752833AbYIXIdQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752833AbYIXIdQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2008 04:33:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751437AbYIXIdH
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 24 Sep 2008 04:33:07 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:41241 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751345AbYIXIdG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2008 04:33:06 -0400
Date: Wed, 24 Sep 2008 10:32:55 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Dmitry Adamushko <dmitry.adamushko@gmail.com>
Cc: Peter Oruba <peter.oruba@amd.com>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: x86, microcode_amd: cleanup, mark request_microcode_user() as
	unsupported
Message-ID: <20080924083255.GA5576@elte.hu>
References: <1222203395.23615.1.camel@earth>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1222203395.23615.1.camel@earth>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-ELTE-VirusStatus: clean
X-ELTE-SpamScore: -1.5
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-1.5 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.3
	-1.5 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Dmitry Adamushko <dmitry.adamushko@gmail.com> wrote:

> Subject: x86, microcode_amd: cleanup, mark request_microcode_user() as unsupported
> 
> (1) mark mc_size in generic_load_microcode() as unitialized_var to 
> avoid gcc's (false) warning;
> 
> (2) mark request_microcode_user() as unsupported. The required changes 
> can be added later. Note, we don't break any user-space interfaces 
> here, as there were no kernels with support for AMD-specific ucode 
> update yet. The ucode has to be updated via 'firmware'.
> 
> Signed-off-by: Dmitry Adamushko <dmitry.adamushko@gmail.com>
> CC: Peter Oruba <peter.oruba@amd.com>

applied to tip/x86/microcode, thanks Dmitry!

	Ingo
