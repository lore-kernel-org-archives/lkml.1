Return-Path: <linux-kernel-owner+w=401wt.eu-S1755361AbYGIVoF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755361AbYGIVoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 17:44:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752217AbYGIVnz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 17:43:55 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52132 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967AbYGIVny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 17:43:54 -0400
Message-ID: <48752F89.6020809@zytor.com>
Date: Wed, 09 Jul 2008 17:37:13 -0400
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Jeremy Fitzhardinge <jeremy@goop.org>
CC: Arjan van de Ven <arjan@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Mike Travis <travis@sgi.com>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com>	<m1abgqzv3g.fsf@frodo.ebiederm.org>	<20080709200757.GD14009@elte.hu>	<48751B57.8030605@goop.org> <20080709133958.612635f0@infradead.org> <4875231F.1020506@zytor.com> <487524A0.6020304@goop.org> <487529AE.3060505@zytor.com> <48752CF0.20908@goop.org>
In-Reply-To: <48752CF0.20908@goop.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> 
> If you're going to do another linker pass, you could have a script to 
> extract all the percpu symbols and generate a set of derived zero-based 
> ones and then link against that.
> 
> Or generate a vmlinux with relocations and "relocate" all the percpu 
> symbols down to 0.
> 

Yeah, I'd hate to have to go to either of those lengths though.

	-hpa
