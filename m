Return-Path: <linux-kernel-owner+w=401wt.eu-S1761490AbZDGPZt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761490AbZDGPZt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Apr 2009 11:25:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759654AbZDGPLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Apr 2009 11:11:54 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:28292 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759617AbZDGPLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Apr 2009 11:11:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=e/EQQ+HtvW8EBAyqKy8iEWLBat2NiviBFMaVIApTLatpy6V2cj04ohBFV+Qo25W/AM
         8Jk1NlJdQWNAHmE/OkU/Ya3uqw1neJDcWGG9AWASTbvpaNgQaah2jrPV0ob/QH00vuw+
         jbr08PbCdMJDH5SvTvhIDBA6mzELZFp6OXbfA=
Date: Tue, 7 Apr 2009 19:11:48 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: mingo@elte.hu, x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/13] x86: move x86_quirk_pre_intr_init() to
	irqinit_32.c
Message-ID: <20090407151148.GE8146@lenovo>
References: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1239112120-676-1-git-send-email-penberg@cs.helsinki.fi>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Pekka Enberg - Tue, Apr 07, 2009 at 04:48:28PM +0300]
| Impact: cleanup
| 
| In preparation for unifying irqinit_{32,64}.c, make
| x86_quirk_pre_intr_init() local to irqinit_32.c.
| 
| Signed-off-by: Pekka Enberg <penberg@cs.helsinki.fi>
| ---
|  arch/x86/include/asm/i8259.h |    4 ----
|  arch/x86/include/asm/setup.h |    1 -
|  arch/x86/kernel/irqinit_32.c |   20 +++++++++++++++++++-
|  arch/x86/kernel/setup.c      |   18 ------------------
|  4 files changed, 19 insertions(+), 24 deletions(-)

Hi Pekka,

it seems you've messed with Ingo's email address :) (fixed).
Btw, I sent same series a bit ago -- maybe you could
take a look on it as well? http://lkml.org/lkml/2009/3/29/214

        Cyrill
