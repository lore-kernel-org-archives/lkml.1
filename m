Return-Path: <linux-kernel-owner+w=401wt.eu-S1759391AbYHAVru@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759391AbYHAVru (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2008 17:47:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754448AbYHAVrm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 1 Aug 2008 17:47:42 -0400
Received: from mta23.gyao.ne.jp ([125.63.38.249]:36435 "EHLO mx.gate01.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753895AbYHAVrm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2008 17:47:42 -0400
Date: Sat, 2 Aug 2008 06:46:55 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: David Howells <dhowells@redhat.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] binfmt_elf_fdpic: Support auxvec base platform string.
Message-ID: <20080801214655.GB13448@linux-sh.org>
Mail-Followup-To: Paul Mundt <lethal@linux-sh.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, linux-sh@vger.kernel.org,
	linux-kernel@vger.kernel.org
References: <20080728150430.GB16555@linux-sh.org> <20080728150359.GA16555@linux-sh.org> <27519.1217599021@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <27519.1217599021@redhat.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 01, 2008 at 02:57:01PM +0100, David Howells wrote:
> Paul Mundt <lethal@linux-sh.org> wrote:
> 
> > +	nitems = 1 + DLINFO_ITEMS + (k_platform ? 1 : 0) + \
> > +		(k_base_platform ? 1 : 0) + AT_VECTOR_SIZE_ARCH;
> 
> Why the backslash?
> 
Habitual behavioural patterns?

If you feel strongly about it it can just be edited out of the patch.
