Return-Path: <linux-kernel-owner+w=401wt.eu-S1754441AbZCIQx2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754441AbZCIQx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Mar 2009 12:53:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752271AbZCIQxS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 9 Mar 2009 12:53:18 -0400
Received: from mx2.redhat.com ([66.187.237.31]:60473 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752157AbZCIQxQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:53:16 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20090302215845.GA22307@redhat.com>
References: <20090302215845.GA22307@redhat.com> <20090225190211.GA7445@redhat.com> <20090225193927.1ED25FC3DA@magilla.sf.frob.com> <alpine.LFD.2.00.0902251156160.3111@localhost.localdomain> <20090225212039.GA11883@redhat.com> <20090226215945.GA12520@redhat.com> <alpine.LFD.2.00.0902261410581.3111@localhost.localdomain> <20090226223031.GA14477@redhat.com> <20090302212256.GA19262@redhat.com> <alpine.LFD.2.00.0903021332130.3111@localhost.localdomain> 
To: Oleg Nesterov <oleg@redhat.com>
Cc: dhowells@redhat.com, Linus Torvalds <torvalds@linux-foundation.org>,
       Roland McGrath <roland@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Chris Evans <scarybeasts@gmail.com>, Don Howard <dhoward@redhat.com>,
       Eugene Teo <eugene@redhat.com>,
       Michael Kerrisk <mtk.manpages@googlemail.com>,
       Tavis Ormandy <taviso@sdf.lonestar.org>,
       Vitaly Mayatskikh <vmayatsk@redhat.com>, stable@kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] copy_process: fix CLONE_PARENT && parent_exec_id interaction
Date: Mon, 09 Mar 2009 16:45:56 +0000
Message-ID: <2712.1236617156@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oleg Nesterov <oleg@redhat.com> wrote:

> -	/* Our parent execution domain becomes current domain
> -	   These must match for thread signalling to apply */

Should you retain this comment somewhere?

David
