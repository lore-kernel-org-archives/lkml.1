Return-Path: <linux-kernel-owner+w=401wt.eu-S1756485AbYGIUvJ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756485AbYGIUvJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:51:09 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753344AbYGIUu4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:50:56 -0400
Received: from gw.goop.org ([64.81.55.164]:35537 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbYGIUu4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:50:56 -0400
Message-ID: <487524A0.6020304@goop.org>
Date: Wed, 09 Jul 2008 13:50:40 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org>	<20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org> <4875231F.1020506@zytor.com>
In-Reply-To: <4875231F.1020506@zytor.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin wrote:
> 1. it means pda references are invalid if their offsets are ever more 
> than CONFIG_PHYSICAL_BASE (which I do not think is likely, but still...)

Why?

As an aside, could we solve the problems by making CONFIG_PHYSICAL_BASE 
0 - putting the percpu variables as the first thing in the kernel - and 
relocating on load?  That would avoid having to make a special PT_LOAD 
segment at 0.  Hm, would that result in the pda and the boot params 
getting mushed together?

    J
