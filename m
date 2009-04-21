Return-Path: <linux-kernel-owner+w=401wt.eu-S1755035AbZDUUJx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755035AbZDUUJx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Apr 2009 16:09:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752038AbZDUUJo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Apr 2009 16:09:44 -0400
Received: from mail-ew0-f176.google.com ([209.85.219.176]:34354 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751161AbZDUUJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Apr 2009 16:09:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=SRNqF/NQ7ZNQ6IsKWePRFmG+1wtUUWZakS+jhGM7V5STDG+0kNhncOkab10fjSYGSC
         KdM8//V0TS40vV82tRSdrIVBFCL3k4Cc/0qF6qMHrdmPvIgmoxB7CLWKZXRIElj8LAow
         AvRzo4UYLA3LwjpUMKS4rlu9zv/RNC87gAh0M=
MIME-Version: 1.0
In-Reply-To: <1240344440.5861.10.camel@earth>
References: <1240258569.6195.8.camel@earth> <1240344440.5861.10.camel@earth>
Date: Tue, 21 Apr 2009 22:09:41 +0200
Message-ID: <b647ffbd0904211309n2a1295b1jb5d2174fa3e7a5f7@mail.gmail.com>
Subject: Re: [PATCH] x86 microcode: work_on_cpu and cleanup of the 
	synchronization logic
From: Dmitry Adamushko <dmitry.adamushko@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
       Andreas Herrmann <andreas.herrmann3@amd.com>,
       Peter Oruba <peter.oruba@amd.com>,
       Arjan van de Ven <arjan@infradead.org>, Hugh Dickins <hugh@veritas.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2009/4/21 Dmitry Adamushko <dmitry.adamushko@gmail.com>:
>
> The version below is based on the latest -git.

Sorry, forgot to add a diif-stat.

 arch/x86/include/asm/microcode.h  |   10 ++-
 arch/x86/kernel/microcode_amd.c   |   10 --
 arch/x86/kernel/microcode_core.c  |  223 ++++++++++++++++++++++---------------
 arch/x86/kernel/microcode_intel.c |   19 ---
 4 files changed, 141 insertions(+), 121 deletions(-)

There are about 20 new comment lines.


-- 
Best regards,
Dmitry Adamushko
