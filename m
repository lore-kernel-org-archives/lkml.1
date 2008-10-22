Return-Path: <linux-kernel-owner+w=401wt.eu-S1752536AbYJVENs@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536AbYJVENs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2008 00:13:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750725AbYJVENk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 22 Oct 2008 00:13:40 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:34379 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750696AbYJVENj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2008 00:13:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=FGPnf+LBw2ueYn/XQ9L7CCb4KtEHUCXQmJXjoNYjst9tb1NVGMf9GWafJ8dVcV/yAa
         PvUQYy3aM/ymTLcubF6KIrj5kWCJZ3bINhCyIvzDIgXD95EIa5oE4raGEY/x9C92VIoo
         2xzRDVaQU51wNKlbMoj1b58iTeUECTz0DvqK0=
Message-ID: <48FEA86C.9030909@gmail.com>
Date: Wed, 22 Oct 2008 13:13:32 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20071114)
MIME-Version: 1.0
To: Linda Walsh <smartmontools@tlinx.org>
CC: Smartmontools Mailing List 
	<smartmontools-support@lists.sourceforge.net>,
       Bruce Allen <ballen@gravity.phys.uwm.edu>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: Promise SATA-standby +selftest=hungdrive; Sil works...
References: <Pine.LNX.4.64.0809142159550.18213@gc.phys.uwm.edu> <48E1B8F8.3090205@gmail.com> <48E26BDA.8080804@tlinx.org> <48E26E61.2010705@gmail.com> <48E34BC8.3050009@tlinx.org> <48E6DE07.70706@gmail.com> <48EAAF2E.4060407@tlinx.org> <48EAB672.3010209@gmail.com> <48EABD07.6030506@tlinx.org> <48EABE8E.9070809@gmail.com> <48EBE263.8000500@tlinx.org> <48EBF7F7.8080908@gmail.com> <48FEA0C5.5000802@tlinx.org>
In-Reply-To: <48FEA0C5.5000802@tlinx.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linda Walsh wrote:
> This is with 2.6.26.5  (there are multiple other problems with 2.6.27[.0]).
> 
> The problem with the drive going "offline" doesn't happen with a
> sil_sata(3124) controller -- so no need to unplug and replug...
> 
> 
> I.e. when the drives are in standby, if smartd or a smartctl command
> attempts to run a drive self-test (short), I get timeout errors from the
> Promise controller (which hangs the sys if I try unplugging/replugging
> the cable to the hung drive).
> The drives correctly spin up to speed and perform the short-test with
> the sil controller.
> 
> It would seem there is a problem with the Promise controller or driver?

Yeah, Mikael found out that hardreset requires controller reset before
it.  Hopefully, it will be fixed soon.

Thanks.

-- 
tejun
