Return-Path: <linux-kernel-owner+w=401wt.eu-S1758937AbZFILak@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758937AbZFILak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Jun 2009 07:30:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758205AbZFILac
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 9 Jun 2009 07:30:32 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:44748 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756847AbZFILac (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Jun 2009 07:30:32 -0400
Subject: Re: [patch 19/87] Fix oops on close of hot-unplugged FTDI serial
 converter
From: David Woodhouse <dwmw2@infradead.org>
To: Greg KH <gregkh@suse.de>, Alan Stern <stern@rowland.harvard.edu>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "stable@kernel.org" <stable@kernel.org>,
       Justin Forbes <jmforbes@linuxtx.org>,
       Zwane Mwaikambo <zwane@arm.linux.org.uk>,
       "Theodore Ts'o" <tytso@mit.edu>, Randy Dunlap <rdunlap@xenotime.net>,
       Dave Jones <davej@redhat.com>, Chuck Wolber <chuckw@quantumlinux.com>,
       Chris Wedgwood <reviews@ml.cw.f00f.org>,
       Michael Krufky <mkrufky@linuxtv.org>, Chuck Ebbert <cebbert@redhat.com>,
       Domenico Andreoli <cavokz@gmail.com>, Willy Tarreau <w@1wt.eu>,
       Rodrigo Rubira Branco <rbranco@la.checkpoint.com>,
       Jake Edge <jake@lwn.net>, Eugene Teo <eteo@redhat.com>,
       "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "alan@lxorguk.ukuu.org.uk" <alan@lxorguk.ukuu.org.uk>
In-Reply-To: <20090609094056.465155618@blue.kroah.org>
References: <20090609093848.204935043@blue.kroah.org>
	 <20090609094056.465155618@blue.kroah.org>
Content-Type: text/plain
Date: Tue, 09 Jun 2009 12:30:11 +0100
Message-Id: <1244547011.4538.7.camel@macbook.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.2 (2.26.2-1.fc11) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-06-09 at 02:39 -0700, Greg KH wrote:
> 2.6.29-stable review patch.  If anyone has any objections, please let
> us know.

Many USB-serial drivers have similar problems; Alan Stern posted a
better fix which splits the shutdown() method into separate disconnect()
and release().

Admittedly, he didn't include ftdi in his patch because it already had
this workaround submitted -- but Alan's approach is better. We should
probably fix ftdi that way, not with this patch.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation

