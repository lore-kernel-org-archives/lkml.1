Return-Path: <linux-kernel-owner+w=401wt.eu-S1756625AbYCNPTm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756625AbYCNPTm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 11:19:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752367AbYCNPTe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 11:19:34 -0400
Received: from public.id2-vpn.continvity.gns.novell.com ([195.33.99.129]:44736
	"EHLO public.id2-vpn.continvity.gns.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751865AbYCNPTe convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 11:19:34 -0400
Message-Id: <47DAA5C2.76E4.0078.0@novell.com>
X-Mailer: Novell GroupWise Internet Agent 7.0.3 Beta 
Date: Fri, 14 Mar 2008 15:20:18 +0000
From: "Jan Beulich" <jbeulich@novell.com>
To: "Jeremy Fitzhardinge" <jeremy@goop.org>
Cc: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: simplify sync_test_bit()
References: <47DA3DC0.76E4.0078.0@novell.com> <47DA93D0.4050708@goop.org>
In-Reply-To: <47DA93D0.4050708@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>#define sync_test_bit(nr, addr) test_bit(nr, addr)
>
>would be better, but seems reasonable to me. Or even an inline for 
>consistency.

I'm usually intentionally using just the names, without parameters and
not as inline, in such alias definitions so that in case the name gets used
as a function pointer (arguably unlikely here) there's not going to be
any missing definition or duplicate function instantiation. But from a
functionality point of view, either of the alternatives you suggest is
of course as good.

Jan

