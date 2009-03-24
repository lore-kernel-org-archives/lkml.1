Return-Path: <linux-kernel-owner+w=401wt.eu-S1758620AbZCXJXO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758620AbZCXJXO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Mar 2009 05:23:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758397AbZCXJWm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Mar 2009 05:22:42 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:32890 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757985AbZCXJWm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Mar 2009 05:22:42 -0400
Subject: Re: [PATCH] kmemtrace: fix build breakage in befs
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ingo Molnar <mingo@elte.hu>
Cc: eduard.munteanu@linux360.ro, linux-kernel@vger.kernel.org
In-Reply-To: <20090324091742.GB6605@elte.hu>
References: <1237884230.25315.33.camel@penberg-laptop>
	 <20090324085128.GF13016@elte.hu> <1237884846.25315.37.camel@penberg-laptop>
	 <20090324085658.GG13016@elte.hu> <1237885074.25315.43.camel@penberg-laptop>
	 <20090324090757.GH13016@elte.hu> <1237886113.25315.49.camel@penberg-laptop>
	 <20090324091742.GB6605@elte.hu>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 24 Mar 2009 11:22:39 +0200
Message-Id: <1237886559.25315.60.camel@penberg-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-03-24 at 10:17 +0100, Ingo Molnar wrote:
> > OK, I think all of them are now fixed. I haven't yet been able to 
> > complete a build so help is still appreciated. ;-)
> 
> unless there's a mail delay, we still have:
> 
> lib/decompress_unlzma.c:122: error: implicit declaration of function ‘kfree’
> lib/decompress_unlzma.c:551: error: implicit declaration of function ‘kmalloc’

Sorry, I missed that. I was testing the .config you sent in the initial
mail, not allyesconfig. I sent you a patch to fix that as well now.

			Pekka

