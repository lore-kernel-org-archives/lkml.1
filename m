Return-Path: <linux-kernel-owner+w=401wt.eu-S1760351AbYFDKqk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760351AbYFDKqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2008 06:46:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759121AbYFDKqa
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jun 2008 06:46:30 -0400
Received: from gw.goop.org ([64.81.55.164]:39040 "EHLO mail.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757838AbYFDKqa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2008 06:46:30 -0400
Message-ID: <4846725D.4090607@goop.org>
Date: Wed, 04 Jun 2008 11:45:49 +0100
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Mike Travis <travis@sgi.com>
CC: Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Christoph Lameter <clameter@sgi.com>,
       David Miller <davem@davemloft.net>, Eric Dumazet <dada1@cosmosbay.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: collapse the various size-dependent percpu accessors
 together
References: <20080604003018.538497000@polaris-admin.engr.sgi.com> <48466BFB.40004@goop.org>
In-Reply-To: <48466BFB.40004@goop.org>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeremy Fitzhardinge wrote:
> We can use gcc's %z modifier to emit the appropriate size suffix for
> an instruction, so we don't need to duplicate the asm statement for
> each size.

Nah, it's a disaster.  Drop this one.

    J
