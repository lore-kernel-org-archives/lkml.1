Return-Path: <linux-kernel-owner+w=401wt.eu-S1755914AbYGIULb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755914AbYGIULb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2008 16:11:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753724AbYGIULW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Jul 2008 16:11:22 -0400
Received: from gw.goop.org ([64.81.55.164]:60431 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750926AbYGIULV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2008 16:11:21 -0400
Message-ID: <48751B57.8030605@goop.org>
Date: Wed, 09 Jul 2008 13:11:03 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: "Eric W. Biederman" <ebiederm@xmission.com>, Mike Travis <travis@sgi.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Christoph Lameter <cl@linux-foundation.org>,
       Jack Steiner <steiner@sgi.com>, linux-kernel@vger.kernel.org,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC 00/15] x86_64: Optimize percpu accesses
References: <20080709165129.292635000@polaris-admin.engr.sgi.com> <m1abgqzv3g.fsf@frodo.ebiederm.org> <20080709200757.GD14009@elte.hu>
In-Reply-To: <20080709200757.GD14009@elte.hu>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar wrote:
> Note that the zero-based percpu problems are completely unrelated to 
> stackprotector. I was able to hit them with a stackprotector-disabled 
> gcc-4.2.3 environment.

The only reason we need to keep a zero-based pda is to support 
stack-protector.  If we drop drop it, we can drop the pda - and its 
special zero-based properties - entirely.

    J
