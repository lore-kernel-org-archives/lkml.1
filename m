Return-Path: <linux-kernel-owner+w=401wt.eu-S1765685AbYCDSSw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1765685AbYCDSSw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 13:18:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759454AbYCDSSl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 13:18:41 -0500
Received: from el-out-1112.google.com ([209.85.162.179]:62998 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757988AbYCDSSk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 13:18:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=aR0pgqp1RmOQd7LD0MswPcdyBeFn9F0wFPJELisgyCSI/uwyMRa9mfe/eff3Y3Wk8VdJjkf9UaGSF0cq3e/Eo590JZbrhm1CQ7s22bQs9g7/GFSeX/nxfrRQBY3tS8qwBr1Aw8unh6yEPnZhccM8TjsdL8NGdHW8n65k3IthMpU=
Subject: Re: [patch] x86: phase out forced inlining
From: Harvey Harrison <harvey.harrison@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Ingo Molnar <mingo@elte.hu>, Sam Ravnborg <sam@ravnborg.org>,
       Adrian Bunk <bunk@kernel.org>, Alexey Starikovskiy <aystarik@gmail.com>,
       lenb@kernel.org, astarikovskiy@suse.de, linux-acpi@vger.kernel.org,
       linux-kernel@vger.kernel.org, Arjan van de Ven <arjan@infradead.org>,
       Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <47CD9060.9000708@zytor.com>
References: <20080301183550.GC25835@cs181133002.pp.htv.fi>
	 <20080303085720.GD15943@elte.hu>
	 <20080303091314.GC4457@cs181133002.pp.htv.fi>
	 <20080303091714.GA18250@elte.hu>
	 <20080303093103.GA23651@uranus.ravnborg.org>
	 <20080303103933.GC21190@elte.hu>
	 <20080303113451.GF4457@cs181133002.pp.htv.fi>
	 <20080303114533.GA4183@elte.hu> <20080303121335.GA15381@elte.hu>
	 <20080303145623.GA25697@uranus.ravnborg.org>
	 <20080304164605.GA16379@elte.hu> <1204654039.5698.13.camel@brick>
	 <47CD9060.9000708@zytor.com>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 10:18:37 -0800
Message-Id: <1204654717.5698.18.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-03-04 at 10:09 -0800, H. Peter Anvin wrote:
> Harvey Harrison wrote:
> > On Tue, 2008-03-04 at 17:46 +0100, Ingo Molnar wrote:
> >> * Sam Ravnborg <sam@ravnborg.org> wrote:
> > 
> >> i dont know why they there are so many variants, but all of them seem to 
> >> be used throughout the kernel:
> >>
> >>    inline    : 25648
> > 
> > I'll assume this is the preferred way of saying it.
> > 
> >>  __inline__  : 1380
> > 
> > Lots of them in include/asm-*...not sure if there is a reason for this.
> > 
> 
> Preferred form for code that's exported to userspace (since gcc 
> complains with -ansi -pedantic otherwise.)
> 
> 	-hpa

