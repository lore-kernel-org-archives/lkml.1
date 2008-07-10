Return-Path: <linux-kernel-owner+w=401wt.eu-S1759224AbYGJRNn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759224AbYGJRNn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 13:13:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752606AbYGJRNg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 13:13:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59555 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751372AbYGJRNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 13:13:35 -0400
Message-ID: <48764307.20905@linux-foundation.org>
Date: Thu, 10 Jul 2008 12:12:39 -0500
From: Christoph Lameter <cl@linux-foundation.org>
User-Agent: Thunderbird 2.0.0.14 (Windows/20080421)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Mike Travis <travis@sgi.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       Andrew Morton <akpm@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org>	<4875231F.1020506@zytor.com> <487524A0.6020304@goop.org>	<487529AE.3060505@zytor.com> <m1r6a2r9nj.fsf@frodo.ebiederm.org>	<48753A71.2030006@zytor.com> <m18wwahauq.fsf@frodo.ebiederm.org> <48763732.7020805@sgi.com> <487641D6.5060206@goop.org>
In-Reply-To: <487641D6.5060206@goop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:

> You want to virtually map the percpu area?  How and when would it get
> extended?

It would get extended when cpu_alloc() is called and the allocator finds that there is no per cpu memory available.


