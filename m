Return-Path: <linux-kernel-owner+w=401wt.eu-S1755708AbYKTXVf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755708AbYKTXVf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2008 18:21:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752266AbYKTXV2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Nov 2008 18:21:28 -0500
Received: from ozlabs.org ([203.10.76.45]:50051 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751210AbYKTXV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2008 18:21:27 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Christoph Lameter <cl@linux-foundation.org>
Subject: Re: [PATCH] Allocate module.ref array dynamically
Date: Fri, 21 Nov 2008 09:51:24 +1030
User-Agent: KMail/1.10.1 (Linux/2.6.27-7-generic; KDE/4.1.2; i686; ; )
Cc: Eric Dumazet <dada1@cosmosbay.com>, Takashi Iwai <tiwai@suse.de>,
       Andreas Gruenbacher <agruen@suse.de>, Jan Blunck <jblunck@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Mike Travis <travis@sgi.com>
References: <s5htzaekp6o.wl%tiwai@suse.de> <200811161030.34054.rusty@rustcorp.com.au> <Pine.LNX.4.64.0811201038580.19948@quilx.com>
In-Reply-To: <Pine.LNX.4.64.0811201038580.19948@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200811210951.24894.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 21 November 2008 03:17:24 Christoph Lameter wrote:
> > 7) Make percpu area grow dynamically.
> >    - Yes, but a thorny tangle esp. with IA64.  The cmdline hack is
> > probably sufficient meanwhile, and parallels can be drawn with vmalloc.
>
> Allright. Please check with David Miller who wants to allocate thousands
> of network interfaces which all need a MIB block.

Yes, I'm already battling Dave over percpu issues.  I'll add this to the list 
:)

Thanks for the warning,
Rusty.
