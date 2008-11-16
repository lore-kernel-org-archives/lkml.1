Return-Path: <linux-kernel-owner+w=401wt.eu-S1755523AbYKPVmT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523AbYKPVmT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 16:42:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753764AbYKPVmI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 16:42:08 -0500
Received: from ozlabs.org ([203.10.76.45]:46541 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753572AbYKPVmI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 16:42:08 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] Allocate module.ref array dynamically
Date: Mon, 17 Nov 2008 08:11:57 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: Eric Dumazet <dada1@cosmosbay.com>, Takashi Iwai <tiwai@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
References: <s5htzaekp6o.wl%tiwai@suse.de> <Pine.LNX.4.64.0811131759250.7010@quilx.com> <200811161030.34054.rusty@rustcorp.com.au>
In-Reply-To: <200811161030.34054.rusty@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811170811.58111.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 16 November 2008 10:30:33 Rusty Russell wrote:
> There are 4 places which use __alloc_percpu, and all of
> them can be converted to alloc_percpu (see patch below).

No they can't: that patch was crap.

The three files which use __alloc_percpu will need conversion.

Sorry,
Rusty.
