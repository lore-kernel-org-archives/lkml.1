Return-Path: <linux-kernel-owner+w=401wt.eu-S1753084AbYASFI4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753084AbYASFI4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jan 2008 00:08:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750945AbYASFIt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 19 Jan 2008 00:08:49 -0500
Received: from mx2.suse.de ([195.135.220.15]:59203 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbYASFIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jan 2008 00:08:48 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: Harvey Harrison <harvey.harrison@gmail.com>
Subject: Re: [PATCH] x86: Unify printk strings in fault_32|64.c
Date: Sat, 19 Jan 2008 06:08:42 +0100
User-Agent: KMail/1.9.6
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>
References: <1200716549.5724.150.camel@brick>
In-Reply-To: <1200716549.5724.150.camel@brick>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200801190608.42452.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday 19 January 2008 05:22:29 Harvey Harrison wrote:
> Adding the address of the faulting library missed removing a
> line ending from X86_32.
> 
> Also update the shorter printk format for X86_32 in fault_64.c
> to make it easier to se the remaining differences.

Thanks. I think it was correct initially, but one of the merge steps
with the changing git-x86 caused some hunks to be dropped and the patch 
never quite recovered from that.

-Andi
