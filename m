Return-Path: <linux-kernel-owner+w=401wt.eu-S1755348AbYGITxe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755348AbYGITxe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:53:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751074AbYGITxY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:53:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47762 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750926AbYGITxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:53:23 -0400
Message-ID: <4875170C.4090500@linux-foundation.org>
Date: Wed, 09 Jul 2008 14:52:44 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>, Jack Steiner <steiner@sgi.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <4874F7D9.5060607@linux-foundation.org> <4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org> <487502BD.2020206@goop.org> <487504A8.5040000@linux-foundation.org> <487507E7.6010102@goop.org> <48750945.8000201@linux-foundation.org> <48750C6C.5090606@goop.org> <48750D96.7030407@linux-foundation.org> <4875123F.1070504@goop.org> <20080709194136.GD4804@elte.hu>
In-Reply-To: <20080709194136.GD4804@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:

> that makes sense. Does everyone agree on #1-#2-#3 and then gradual 
> elimination of most pda members (without going through an intermediate 
> renaming of pda members) being the way to go?

I think we all agree on 1-2-3.

The rest is TBD. Hope Jeremy can add his wisdom there to get the pda.X replaced by the proper percpu names for 32 bit. 

With Jeremy's approach we would be doing two steps at once (getting rid of pda ops plus unifying the variable names between 32 and 64 bit). Maybe more difficult to verify correctness. The removal of the pda ops is a pretty straighforward conversion.
