Return-Path: <linux-kernel-owner+w=401wt.eu-S1752906AbXCaNCB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752906AbXCaNCB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 09:02:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752987AbXCaNCB
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 09:02:01 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:57501 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752904AbXCaNCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 09:02:00 -0400
Date: Sat, 31 Mar 2007 14:01:49 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Frank Ch. Eigler" <fche@redhat.com>
Cc: "Stone, Joshua I" <joshua.i.stone@intel.com>,
       "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       SystemTAP <systemtap@sources.redhat.com>,
       Satoshi Oshima <soshima@redhat.com>, Hideo Aoki <haoki@redhat.com>,
       Yumiko Sugita <yumiko.sugita.yf@hitachi.com>, hch@infradead.org
Subject: Re: [RFC][Patch 1/4] kprobe fast unregistration
Message-ID: <20070331130149.GA18345@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Frank Ch. Eigler" <fche@redhat.com>,
	"Stone, Joshua I" <joshua.i.stone@intel.com>,
	"Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
	Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
	Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
	Prasanna S Panchamukhi <prasanna@in.ibm.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	SystemTAP <systemtap@sources.redhat.com>,
	Satoshi Oshima <soshima@redhat.com>, Hideo Aoki <haoki@redhat.com>,
	Yumiko Sugita <yumiko.sugita.yf@hitachi.com>
References: <20070323180527.GA13728@bambi.jf.intel.com> <16D5B9AB904B0B46B22A27002EE3A8C82793BB@scsmsx415.amr.corp.intel.com> <20070323182248.GA32364@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20070323182248.GA32364@redhat.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 02:22:48PM -0400, Frank Ch. Eigler wrote:
> Really?  What possible problems can occur?  The worst that occurs to
> me is that if someone forgets to call the commit function, the kprobes
> will still be disabled, but memory won't be recycled for a while.

Exactly.  It's a very unintuitive interface, exposing implementation
details to the user.  The array variant otoh is obvious to the user:
gice me an array of probes to register/unregister and do it.

> Would it be possible to allay even that concern with an automated
> deferred/periodic commit?

That's even worse from the user perspective interface. 

