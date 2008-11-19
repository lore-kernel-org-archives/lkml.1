Return-Path: <linux-kernel-owner+w=401wt.eu-S1754303AbYKSVR3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303AbYKSVR3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2008 16:17:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753085AbYKSVRU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Nov 2008 16:17:20 -0500
Received: from yw-out-2324.google.com ([74.125.46.31]:8554 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753129AbYKSVRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2008 16:17:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=cc:message-id:from:to:in-reply-to:content-type
         :content-transfer-encoding:mime-version:subject:date:references
         :x-mailer;
        b=gCOT3g9dfSV9do2q84LyEdi53Yua9A3fGnlZLcp2Ig2/45mfiQ+EaGIY3tzU9I0Pb0
         qvRaFsO4hRmGNmHiC2874fZDZdlj4n1/TV6GM62trwakUz+Yy+SXesKFtqApyaj449Ej
         Hax19zBpQjzPFqRHukPb3cIOIG5suHG65VhI8=
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Message-Id: <FF8068EB-1E4F-4D84-93B3-520922C5C1D4@gmail.com>
From: Richard Holden <aciddeath@gmail.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
In-Reply-To: <20081119175917.7d21cf77.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0 (Apple Message framework v929.2)
Subject: Re: linux-next: Tree for November 19 (section mismatche fpu_init)
Date: Wed, 19 Nov 2008 14:17:15 -0700
References: <20081119175917.7d21cf77.sfr@canb.auug.org.au>
X-Mailer: Apple Mail (2.929.2)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

WARNING: arch/x86/kernel/built-in.o(.cpuinit.text+0x1d6): Section  
mismatch in reference from the function fpu_init() to the  
function .init.text:init_thread_xstate()
The function __cpuinit fpu_init() references
a function __init init_thread_xstate().
If init_thread_xstate is only used by fpu_init then
annotate init_thread_xstate with a matching annotation.

appears in arch/x86/kernel/built-in.o

-Richard Holden
