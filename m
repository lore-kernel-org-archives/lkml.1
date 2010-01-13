Return-Path: <linux-kernel-owner+w=401wt.eu-S1755110Ab0AMNev@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755110Ab0AMNev (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jan 2010 08:34:51 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755020Ab0AMNeu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Jan 2010 08:34:50 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:38698 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754965Ab0AMNet (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jan 2010 08:34:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=VhktkBrUWGVs5xwYuBvhKdMO3oZ4oTIU1v8uAco8e4eoLO1iXyzPdjhmAzpSiWr5hc
         Yhz5gaE6cgk+abj5BDXHsZ5S47tOJgiuNGyjFNaUvgwXX/eDlrpEpS7YykD6ZxjGgph0
         ngRn1EccRB+L1/Q7gqlK1s93cSbbq6HbyNHNI=
Date: Wed, 13 Jan 2010 14:34:45 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>
Subject: Re: [PATCH 1/3] rbtree: Introduce rb_for_each_entry
Message-ID: <20100113133442.GB5036@nowhere>
References: <1263387673-15231-1-git-send-email-acme@infradead.org> <1263388569.4244.215.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1263388569.4244.215.camel@laptop>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 13, 2010 at 02:16:09PM +0100, Peter Zijlstra wrote:
> On Wed, 2010-01-13 at 11:01 -0200, Arnaldo Carvalho de Melo wrote:
> > From: Arnaldo Carvalho de Melo <acme@redhat.com>
> > 
> > Similar to list_for_each_entry, helps reducing boilerplate in many
> > places and makes rbtrees closer to list.h macros.
> > 
> > First conversion will be in the tools/perf.
> 
> I'm still not sure you really want to do this, it might give people the
> impression its a sane thing to do ;-)


At least it matches many patterns in perf :)

