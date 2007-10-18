Return-Path: <linux-kernel-owner+w=401wt.eu-S1763666AbXJRWi3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763666AbXJRWi3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2007 18:38:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753901AbXJRWiU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Oct 2007 18:38:20 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:57244 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753703AbXJRWiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2007 18:38:19 -0400
Date: Thu, 18 Oct 2007 15:37:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: ak@suse.de, bwalle@suse.de, linux-kernel@vger.kernel.org,
       kexec@lists.infradead.org, vgoyal@in.ibm.com
Subject: Re: [patch 1/3] Add BSS to resource tree
Message-Id: <20071018153751.c9c458c8.akpm@linux-foundation.org>
In-Reply-To: <20071018221813.GA23801@uranus.ravnborg.org>
References: <20071018111535.356215664@strauss.suse.de>
	<20071018111535.883533731@strauss.suse.de>
	<20071018142642.5b3f6ba4.akpm@linux-foundation.org>
	<20071018214836.GA3459@bingen.suse.de>
	<20071018215827.GB23708@uranus.ravnborg.org>
	<20071018220048.GB3459@bingen.suse.de>
	<20071018221813.GA23801@uranus.ravnborg.org>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2007 00:18:13 +0200
Sam Ravnborg <sam@ravnborg.org> wrote:

> And I recall that extern char sym[] is considered correct by binutils 
> people - but I'm not 100% sure and google did not give me an appropriate hit.

An ancient memory tells me that these things are traditionally
declared as plain old int:

extern int start;
extern int edata;

etc.

However
http://techpubs.sgi.com/library/tpl/cgi-bin/getdoc.cgi?coll=0650&db=man&fname=/usr/share/catman/p_man/cat3/standard/_rt_symbol_table_size.z
disagrees with me.

http://www.psych.upenn.edu/~saul/parasite/man/man3/end.3.html agrees with me

http://docsrv.sco.com:507/en/man/html.S/end.S.html agrees with me

http://www.rocketaware.com/man/man3/end.3.htm agrees with me

http://bama.ua.edu/cgi-bin/man-cgi?etext+3C agrees with me


