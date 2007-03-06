Return-Path: <linux-kernel-owner+w=401wt.eu-S965538AbXCFSVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965538AbXCFSVp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S965539AbXCFSVp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:21:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:33151 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965538AbXCFSVn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:21:43 -0500
Date: Tue, 6 Mar 2007 13:21:34 -0500
From: Dave Jones <davej@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>, alon.barlev@gmail.com,
       ak@suse.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86_64, i386: Add command line length to boot protocol
Message-ID: <20070306182134.GB9491@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>, alon.barlev@gmail.com,
	ak@suse.de, linux-kernel@vger.kernel.org
References: <20070306181430.GB3151@strauss.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070306181430.GB3151@strauss.suse.de>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 06, 2007 at 07:14:30PM +0100, Bernhard Walle wrote:

 > +cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,

Why a long? It's unlikely that someone is going to have a command line
bigger than 0xffff.

	Dave

-- 
http://www.codemonkey.org.uk
