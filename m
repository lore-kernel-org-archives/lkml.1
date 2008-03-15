Return-Path: <linux-kernel-owner+w=401wt.eu-S1753507AbYCODon@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753507AbYCODon (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2008 23:44:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751675AbYCODod
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Mar 2008 23:44:33 -0400
Received: from wf-out-1314.google.com ([209.85.200.171]:39095 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbYCODoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2008 23:44:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LHJbqfZkMg0qRCYHmOKb60Qx12EJyShxxEHnq+oFIAauxaAL3A9rDQbgVjzCeuyl4tawDa4FhnMtwmJ6/sNpXBlCwlLn8oXzGZn2RY9qYhUgc88xtgR4LcW1JN796GiqQR043YVyuwLT0uxeA7sqpVErFr19QvRTsnD1c6J6OMw=
Message-ID: <170fa0d20803142044i3e4d134fq5b287134248a113f@mail.gmail.com>
Date: Fri, 14 Mar 2008 22:44:31 -0500
From: "Mike Snitzer" <snitzer@gmail.com>
To: "Christoph Hellwig" <hch@infradead.org>
Subject: Re: [PATCH 3/6] NLM: Initialize completion variable in lockd_up
Cc: "Jeff Layton" <jlayton@redhat.com>, akpm@linux-foundation.org,
       neilb@suse.de, linux-nfs@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20080113181743.GA20219@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1199820798-5289-1-git-send-email-jlayton@redhat.com>
	 <1199820798-5289-2-git-send-email-jlayton@redhat.com>
	 <1199820798-5289-3-git-send-email-jlayton@redhat.com>
	 <1199820798-5289-4-git-send-email-jlayton@redhat.com>
	 <20080109173542.GA30523@infradead.org>
	 <20080113082718.396890f7@tleilax.poochiereds.net>
	 <20080113181743.GA20219@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jan 13, 2008 at 1:17 PM, Christoph Hellwig <hch@infradead.org> wrote:
>  Btw, lockd() takes BKL just after starting up and only implicitly drops
>  it when blocking.  This seems very dangerous to me and badly wants
>  updating to some real locking scheme..

Can you elaborate on what is meant by lockd "blocking"?  Blocking in
svc_recv() or during a SETLKW or ???

I'm trying to come to terms with why nlmsvc_lock() wouldn't have the
BKL on entry.
