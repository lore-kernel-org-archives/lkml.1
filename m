Return-Path: <linux-kernel-owner+w=401wt.eu-S1757545AbZFINqO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757545AbZFINqO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 09:46:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750844AbZFINqI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 09:46:08 -0400
Received: from mx2.redhat.com ([66.187.237.31]:39948 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750709AbZFINqH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 09:46:07 -0400
Date: Tue, 9 Jun 2009 09:42:17 -0400
From: Chuck Ebbert <cebbert@redhat.com>
To: David Woodhouse <dwmw2@infradead.org>
Cc: Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
Subject: Re: [patch 19/87] Fix oops on close of hot-unplugged FTDI serial
 converter
Message-ID: <20090609094217.2c722ca8@dhcp-100-2-144.bos.redhat.com>
In-Reply-To: <1244547011.4538.7.camel@macbook.infradead.org>
References: <20090609093848.204935043@blue.kroah.org>
	<20090609094056.465155618@blue.kroah.org>
	<1244547011.4538.7.camel@macbook.infradead.org>
Organization: Red Hat, Inc.
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 09 Jun 2009 12:30:11 +0100
David Woodhouse <dwmw2@infradead.org> wrote:

> On Tue, 2009-06-09 at 02:39 -0700, Greg KH wrote:
> > 2.6.29-stable review patch.  If anyone has any objections, please let
> > us know.
> 
> Many USB-serial drivers have similar problems; Alan Stern posted a
> better fix which splits the shutdown() method into separate disconnect()
> and release().
> 
> Admittedly, he didn't include ftdi in his patch because it already had
> this workaround submitted -- but Alan's approach is better. We should
> probably fix ftdi that way, not with this patch.
> 

But this is for -stable, where proven patches are preferred over
yet-to-be-written ones. That rewrite would have to go upstream first.

