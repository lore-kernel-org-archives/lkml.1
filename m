Return-Path: <linux-kernel-owner+w=401wt.eu-S1763367AbZCQKzA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763367AbZCQKzA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Mar 2009 06:55:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753222AbZCQKyw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Mar 2009 06:54:52 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:32168 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752719AbZCQKyv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Mar 2009 06:54:51 -0400
Message-Id: <49BF8FB7.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.0 
Date: Tue, 17 Mar 2009 10:55:35 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Andi Kleen" <andi@firstfloor.org>
Cc: "Jeremy Fitzhardinge" <jeremy.fitzhardinge@citrix.com>,
       "Jeremy Fitzhardinge" <jeremy@goop.org>,
       "Arjan van de Ven" <arjan@infradead.org>,
       "the arch/x86 maintainers" <x86@kernel.org>,
       "Xen-devel" <xen-devel@lists.xensource.com>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [Xen-devel] [PATCH 10/24] xen: mask XSAVE from cpuid
References: <1236931920-6861-11-git-send-email-jeremy@goop.org>
 <49BA3A84.76E4.0078.0@novell.com> <49BA7810.6090807@goop.org>
 <49BD4CE1.6040100@zytor.com> <49BD6D0E.1010107@goop.org>
 <20090315154718.00353625@infradead.org> <49BD97C6.2070401@goop.org>
 <20090315170945.08344b86@infradead.org> <87fxhd2f53.fsf@basil.nowhere.org>
 <49BF6505.76E4.0078.0@novell.com>
 <20090317104817.GO11935@one.firstfloor.org>
In-Reply-To: <20090317104817.GO11935@one.firstfloor.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> Andi Kleen <andi@firstfloor.org> 17.03.09 11:48 >>>
>> No, properly coded xsave support will (hopefully) make user-visible context
>> extensions transparent to hypervisor and OS. But I was giving a general
>> example here, and the change from xmm to ymm registers is one that does
>> need hypervisor (and OS) changes.
>
>Again except for XSAVE support it doesn't, does it?

No, it shouldn't (minus the valid comments hpa added in another reply).

Jan

