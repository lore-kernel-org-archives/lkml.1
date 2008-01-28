Return-Path: <linux-kernel-owner+w=401wt.eu-S1755945AbYA1SY7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755945AbYA1SY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2008 13:24:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755220AbYA1SYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 Jan 2008 13:24:45 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35087 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755240AbYA1SYn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2008 13:24:43 -0500
Date: Mon, 28 Jan 2008 19:58:52 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, jeremy@goop.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: git-x86 oopses in acpi_ps_peek_opcode
Message-ID: <20080128185852.GB25724@one.firstfloor.org>
References: <20080128171907.GA24037@basil.nowhere.org> <20080128173449.GA22487@elte.hu> <20080128183204.GA25724@one.firstfloor.org> <20080128181113.GA5375@elte.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080128181113.GA5375@elte.hu>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2008 at 07:11:13PM +0100, Ingo Molnar wrote:
> 
> * Andi Kleen <andi@firstfloor.org> wrote:
> 
> > > do you still see that crash?
> > 
> > New the second oops in 
> > allocate_threshold_blocks->sysfs_add_file->kobject_uevent_env happens 
> > (see other mail)
> 
> that's a Linus -git problem, the upstream kobject changes - try Greg's 
> and Yinghai Lu's patch below, does it help?

With that it boots again yes

-Andi
