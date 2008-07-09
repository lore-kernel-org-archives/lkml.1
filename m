Return-Path: <linux-kernel-owner+w=401wt.eu-S1755894AbYGITtU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755894AbYGITtU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:49:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbYGITs6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:48:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52520 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755662AbYGITs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:48:57 -0400
Message-ID: <48751551.1020301@zytor.com>
Date: Wed, 09 Jul 2008 15:45:21 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Jeremy Fitzhardinge <jeremy@goop.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <4874F7D9.5060607@linux-foundation.org> <4874FD52.8070000@sgi.com> <4874FFC4.7050505@linux-foundation.org> <487502BD.2020206@goop.org> <487504A8.5040000@linux-foundation.org> <487507E7.6010102@goop.org> <48750945.8000201@linux-foundation.org> <48750C6C.5090606@goop.org> <48750D96.7030407@linux-foundation.org> <4875123F.1070504@goop.org> <20080709194136.GD4804@elte.hu>
In-Reply-To: <20080709194136.GD4804@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> that makes sense. Does everyone agree on #1-#2-#3 and then gradual 
> elimination of most pda members (without going through an intermediate 
> renaming of pda members) being the way to go?
> 

Works for me.

	-hpa
