Return-Path: <linux-kernel-owner+w=401wt.eu-S1760578AbZB0VJ7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760578AbZB0VJ7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Feb 2009 16:09:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759572AbZB0VJm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 27 Feb 2009 16:09:42 -0500
Received: from fk-out-0910.google.com ([209.85.128.185]:52491 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759469AbZB0VJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Feb 2009 16:09:41 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=kpArc25f+XDB3VtbgNwB6NEu0HtbTwrCYwYwi/u4r6zbsqX5RXrHbx9POi7LL+GL/E
         AC4RK3OxPpIexmCJjJ6L9bG/f3cIFjuOto318f6Frbe5bF+gvws9HzNkqphrozCB1EWw
         RiBqt4+SUPdeVyQIAFHmX7EZdRbuUDkDXdSEg=
Date: Sat, 28 Feb 2009 00:16:20 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@elte.hu>,
       containers <containers@lists.linux-foundation.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Oren Laadan <orenl@cs.columbia.edu>, hch@infradead.org
Subject: Re: [RFC][PATCH 3/8] create fs flags to mark c/r supported fs's
Message-ID: <20090227211620.GA3326@x200.localdomain>
References: <20090227203425.F3B51176@kernel> <20090227203428.556600DA@kernel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090227203428.556600DA@kernel>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 27, 2009 at 12:34:28PM -0800, Dave Hansen wrote:
> +#define FS_CHECKPOINTABLE 8

This will ban all sockets, for instance, until all of them are
C/R-ready. And every new socket type must be made C/R-ready from
the very beginning, or risk major C/R breakage.
