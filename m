Return-Path: <linux-kernel-owner+w=401wt.eu-S1760325AbZCTSlR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760325AbZCTSlR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 14:41:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758307AbZCTSlA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 14:41:00 -0400
Received: from outbound-mail-29.bluehost.com ([69.89.17.211]:37937 "HELO
	outbound-mail-29.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751689AbZCTSk7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 14:40:59 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=GfXqfY95/4kEDTAAXKvHm85mFaMhK+EONlLej5l7bn/IZSd/109jRzMhnssWApwpTyghRPcjvR/qDWaSyoJIKVSHK/fAwgSKmhgXoHq01JPOnYtH/EEpZLf0WFKFuaKP;
Date: Fri, 20 Mar 2009 11:40:55 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, linux-pci@vger.kernel.org,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/pci: host mmconfig detect clean up v3 - resend
Message-ID: <20090320114055.649e8d9e@hobbes.lan>
In-Reply-To: <49C313B7.9060704@kernel.org>
References: <20090205181505.GB5661@elte.hu>
	<20090319193218.445ce0ca@hobbes.lan>
	<49C313B7.9060704@kernel.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Mar 2009 20:55:35 -0700
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> Impact: not assume one place for mmconfig in nb
> 
> prepare for following case: amd fam10h + mcp55
> CPU MSR has some range, mcp55 pci config will have another one.
> 
> also prepare for mcp55 + io55 system. every one will have one range.
> 
> if it s mcp55 detect duties to execlude range that is used by CPU MSR
> aka, if CPU state bus 0-255, range in mcp55 need to be dropped.
> because HW in CPU will not route that mcp55 mmconfig to handle it.

I applied this one and cleaned up the changelog considerably.  Please
check to make sure I got the facts right; I may well have butchered it.

-- 
Jesse Barnes, Intel Open Source Technology Center
