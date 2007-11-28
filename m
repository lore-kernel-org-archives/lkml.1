Return-Path: <linux-kernel-owner+w=401wt.eu-S1757414AbXK1Sq3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414AbXK1Sq3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2007 13:46:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751610AbXK1SqV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Nov 2007 13:46:21 -0500
Received: from fxip-0047f.externet.hu ([88.209.222.127]:44234 "EHLO
	dorka.pomaz.szeredi.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751277AbXK1SqV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2007 13:46:21 -0500
To: jdike@addtoit.com
CC: mingo@elte.hu, user-mode-linux-devel@lists.sourceforge.net,
       linux-kernel@vger.kernel.org
In-reply-to: <20071128182935.GA8048@c2.user-mode-linux.org> (message from Jeff
	Dike on Wed, 28 Nov 2007 13:29:35 -0500)
Subject: Re: -rt doesn't compile for UML
References: <E1IxMK0-0006ae-2s@dorka.pomaz.szeredi.hu> <20071128150637.GA5518@c2.user-mode-linux.org> <E1IxOwS-000752-HF@dorka.pomaz.szeredi.hu> <20071128182935.GA8048@c2.user-mode-linux.org>
Message-Id: <E1IxRv7-0007e8-Dq@dorka.pomaz.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 28 Nov 2007 19:46:01 +0100
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

> > Something like:
> > 
> >   dd if=/host/tmp/bigfile of=/tmp/bigfile bs=1048576 count=100
> > 
> > and run 'top' or 'watch something' in another terminal, which
> > sometimes completely stops updating during the write.
> 
> Are you talking about missing updates for a few seconds, or for
> longer?  With the common above, with top -delay 1, and with 600M of
> data, I'm seeing occasional 2-3 pauses, with one missing 5 seconds.

Yes, that sort of thing.  Sometimes it pauses soon after starting the
dd, and never recovers till it's finished, but that is not easily
reproducible.

Miklos
