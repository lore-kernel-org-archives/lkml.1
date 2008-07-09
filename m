Return-Path: <linux-kernel-owner+w=401wt.eu-S1754467AbYGITs4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754467AbYGITs4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 15:48:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753693AbYGITsl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 15:48:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52514 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751526AbYGITsl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 15:48:41 -0400
Message-ID: <48751533.7030602@zytor.com>
Date: Wed, 09 Jul 2008 15:44:51 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Mike Travis <travis@sgi.com>, Jeremy Fitzhardinge <jeremy@goop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <4874F30C.8020800@zytor.com> <4874F909.7060503@goop.org> <4874FEDF.90404@sgi.com> <20080709193404.GC4804@elte.hu>
In-Reply-To: <20080709193404.GC4804@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> 
> the problem is, we cannot just put it even into tip/master if there's no 
> short-term hope of fixing a problem it triggers. gcc-4.2.3 is solid for 
> me otherwise, for series of thousands of randomly built kernels.
> 

4.2.3 is fine; he was using 4.2.0 before, and as far as I know, 4.2.0 
and 4.2.1 are known broken for the kernel.

	-hpa

