Return-Path: <linux-kernel-owner+w=401wt.eu-S1755276AbZCQPzp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755276AbZCQPzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 11:55:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753717AbZCQPzg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 11:55:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:55231 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbZCQPzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 11:55:35 -0400
Date: Tue, 17 Mar 2009 16:55:55 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, "H. Peter Anvin" <hpa@zytor.com>,
       Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       Jeremy Fitzhardinge <jeremy@goop.org>,
       the arch/x86 maintainers <x86@kernel.org>,
       Xen-devel <xen-devel@lists.xensource.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [Xen-devel] [PATCH 10/24] xen: mask XSAVE from cpuid
Message-ID: <20090317155555.GT11935@one.firstfloor.org>
References: <49BD4CE1.6040100@zytor.com> <49BD6D0E.1010107@goop.org> <20090315154718.00353625@infradead.org> <49BD97C6.2070401@goop.org> <20090315170945.08344b86@infradead.org> <49BE6D50.76E4.0078.0@novell.com> <87fxhd2f53.fsf@basil.nowhere.org> <49BEFDFB.8070900@zytor.com> <20090317115621.GQ11935@one.firstfloor.org> <20090317084928.0f17dfb0@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090317084928.0f17dfb0@infradead.org>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> well the choice fundamentally is
> 1) Have correct applications work, even though you might not always get
>    all new features that the hardware could have done.. at the expense
>    that someone who wants to do horrible things can
> 2) Have all latest features always there, but break correctly written
>    apps/oses every 2 years.

I'm not sure there will be that much breakage. It seems more like
a theoretical danger.

> 
> I'd go for option 1 any day of the week, hands down.
> Esp if the "cpu cloaking" kind of things really disable the
> instructions... but even without.

With cpu cloaking and disabling unknown instructions it would be fine
to go conservative.  But that's not what is being proposed.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
