Return-Path: <linux-kernel-owner+w=401wt.eu-S1754712AbXLDWdn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712AbXLDWdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2007 17:33:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752010AbXLDWdf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Dec 2007 17:33:35 -0500
Received: from rv-out-0910.google.com ([209.85.198.191]:33880 "EHLO
	rv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662AbXLDWdf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2007 17:33:35 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=R8OCVDjslk7e82fd+ffrVIHmRO6vsx6NRE0XTA4sdEbXPkJPEf+wGHLLY9gpARlISGMxKDRuVlNLGBTPKoHvg0aeuw4frLmfU52eAjKcnDaReWrhCiKEvc0sB38TkQhfzbg03M4xzuVbMCqIad1UkMCzFwIKW5prVSfvsdnfkqo=
Subject: Re: [RFC PATCH] x86: Unify include/asm-x86/linkage_[32|64].h
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20071204222717.GA25974@elte.hu>
References: <1196801629.10408.26.camel@brick>
	 <20071204213247.GA11216@elte.hu> <1196806868.10408.33.camel@brick>
	 <20071204222717.GA25974@elte.hu>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 14:33:32 -0800
Message-Id: <1196807612.10408.41.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2007-12-04 at 23:27 +0100, Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> > OK, but if this patch is acceptable, then there is no more places in 
> > the tree that define the FASTCALL macro, other than the empty default 
> > in include/linux/linkage.h.  So I think a second step would be to 
> > start to get rid of FASTCALL callers elsewhere in the tree...thoughts?
> 
> the removal of FASTCALL is fine: the default (and only) compiler model 
> for x86 (32-bit) is regparm(3), so the regparm(3) macro is equivalent to 
> the empty one in linux/linkage.h.
> 
> btw., removal of FASTCALL from the tree is worthwile after this: it 
> should probably be done via the -mm tree, because it's more of a generic 
> kernel matter than an arch/x86 matter.
> 
> 	Ingo

Agreed, just noting that there was nobody defining it anymore, it's
widespread enough that I'll submit them separately to appropriate
maintainers and they can dribble in over time.

Cheers,

Harvey

