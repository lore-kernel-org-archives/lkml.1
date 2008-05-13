Return-Path: <linux-kernel-owner+w=401wt.eu-S1760632AbYEMOAL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632AbYEMOAL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 10:00:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757426AbYEMN76
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 09:59:58 -0400
Received: from gw.goop.org ([64.81.55.164]:52257 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206AbYEMN75 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 09:59:57 -0400
Message-ID: <48299ED0.6020402@goop.org>
Date: Tue, 13 May 2008 14:59:44 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "Robert Kaiser (FH)" <kaiser@informatik.fh-wiesbaden.de>
CC: xen-devel@lists.xensource.com, Ingo Molnar <mingo@elte.hu>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [PATCH] xen: remove support for non-PAE 32-bit
References: <48243015.2010801@goop.org> <200805131332.14631.kaiser@informatik.fh-wiesbaden.de> <48298002.5080300@goop.org> <200805131528.09429.kaiser@informatik.fh-wiesbaden.de>
In-Reply-To: <200805131528.09429.kaiser@informatik.fh-wiesbaden.de>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Robert Kaiser (FH) wrote:
>> I think there's a bug in qemu's x86 
>> emulation with respect to mis-reporting the eip of an xchg which faults,
>> which may be what you're seeing.
>>     
>
> The eip that was reported was always the same, and there was no xchg 
> instruction at that address. It might have been consistently wrong though 
> (how would I figure this out?).
>   

The symptom I've observed is that qemu reports the first instruction of 
the basic block rather than the exchange itself.  If you "x/10i <fault 
eip>", you should see an xchg before long.

Either way, sounds like a qemu bug which should be reported to them.

    J
