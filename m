Return-Path: <linux-kernel-owner+w=401wt.eu-S1765012AbYCDSH4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765012AbYCDSH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:07:56 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751370AbYCDSHq
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:07:46 -0500
Received: from gv-out-0910.google.com ([216.239.58.184]:52754 "EHLO
	gv-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215AbYCDSHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:07:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=oG6WYQJ//XvC4xr0AJ/nJqnxAjLCdNY98D71OXXo5SzWBmwNZ0FMxfawpM6gbomQ7B0omUhknWU7UGfa6/IsCVEdcjS0ou7uKTm4amCdnQNpoq4hmhA/1iKyGjFs0ACZ3wLL+4PchmBlYG0ynaVeldTRoBS0OM58CssoMocEwS0=
Subject: Re: [patch] x86: phase out forced inlining
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Sam Ravnborg <sam@ravnborg.org>, Adrian Bunk <bunk@kernel.org>,
       Alexey Starikovskiy <aystarik@gmail.com>, lenb@kernel.org,
       astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
In-Reply-To: <20080304164605.GA16379@elte.hu>
References: <20080301183550.GC25835@cs181133002.pp.htv.fi>
	 <20080303085720.GD15943@elte.hu>
	 <20080303091314.GC4457@cs181133002.pp.htv.fi>
	 <20080303091714.GA18250@elte.hu>
	 <20080303093103.GA23651@uranus.ravnborg.org>
	 <20080303103933.GC21190@elte.hu>
	 <20080303113451.GF4457@cs181133002.pp.htv.fi>
	 <20080303114533.GA4183@elte.hu> <20080303121335.GA15381@elte.hu>
	 <20080303145623.GA25697@uranus.ravnborg.org>
	 <20080304164605.GA16379@elte.hu>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 10:07:19 -0800
Message-Id: <1204654039.5698.13.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2008-03-04 at 17:46 +0100, Ingo Molnar wrote:
> * Sam Ravnborg <sam@ravnborg.org> wrote:

> i dont know why they there are so many variants, but all of them seem to 
> be used throughout the kernel:
> 
>    inline    : 25648

I'll assume this is the preferred way of saying it.

>  __inline__  : 1380

Lots of them in include/asm-*...not sure if there is a reason for this.

>  __inline    : 368

Almost all of them in drivers/scsi

Cheers,

Harvey

