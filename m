Return-Path: <linux-kernel-owner+w=401wt.eu-S1763713AbXKTU5H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763713AbXKTU5H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2007 15:57:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759248AbXKTU4w
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 20 Nov 2007 15:56:52 -0500
Received: from ns2.suse.de ([195.135.220.15]:48625 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756961AbXKTU4v (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2007 15:56:51 -0500
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [rfc 08/45] cpu alloc: x86 support
Date: Tue, 20 Nov 2007 21:51:58 +0100
User-Agent: KMail/1.9.6
Cc: Christoph Lameter <clameter@sgi.com>, akpm@linux-foundation.org,
       travis@sgi.com, Mathieu Desnoyers <mathieu.desnoyers@polymtl.ca>,
       linux-kernel@vger.kernel.org
References: <20071120011132.143632442@sgi.com> <200711201301.25373.ak@suse.de> <474346DE.5050305@zytor.com>
In-Reply-To: <474346DE.5050305@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200711202151.58310.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


> This limitation shouldn't apply to the percpu area, since gs_base can be 
> pointed anywhere in the address space -- in effect we're always indirect.

The initial reference copy of the percpu area has to be addressed by
the linker.

Hmm, in theory since it is not actually used by itself I suppose you could 
move it into positive space.

-Andi
