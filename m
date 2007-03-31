Return-Path: <linux-kernel-owner+w=401wt.eu-S1752988AbXCaNGG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988AbXCaNGG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2007 09:06:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752997AbXCaNGG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 31 Mar 2007 09:06:06 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:56276 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbXCaNGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2007 09:06:04 -0400
Date: Sat, 31 Mar 2007 14:06:01 +0100
From: Christoph Hellwig <hch@infradead.org>
To: "Stone, Joshua I" <joshua.i.stone@intel.com>
Cc: "Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
       Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
       Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
       Prasanna S Panchamukhi <prasanna@in.ibm.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       SystemTAP <systemtap@sources.redhat.com>,
       Satoshi Oshima <soshima@redhat.com>, Hideo Aoki <haoki@redhat.com>,
       Yumiko Sugita <yumiko.sugita.yf@hitachi.com>,
       "Frank Ch. Eigler" <fche@redhat.com>, hch@infradead.org
Subject: Re: [RFC][Patch 1/4] kprobe fast unregistration
Message-ID: <20070331130601.GA18947@infradead.org>
Mail-Followup-To: Christoph Hellwig <hch@infradead.org>,
	"Stone, Joshua I" <joshua.i.stone@intel.com>,
	"Keshavamurthy, Anil S" <anil.s.keshavamurthy@intel.com>,
	Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
	Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
	Prasanna S Panchamukhi <prasanna@in.ibm.com>,
	linux-kernel <linux-kernel@vger.kernel.org>,
	SystemTAP <systemtap@sources.redhat.com>,
	Satoshi Oshima <soshima@redhat.com>, Hideo Aoki <haoki@redhat.com>,
	Yumiko Sugita <yumiko.sugita.yf@hitachi.com>,
	"Frank Ch. Eigler" <fche@redhat.com>
References: <20070323180527.GA13728@bambi.jf.intel.com> <16D5B9AB904B0B46B22A27002EE3A8C82793BB@scsmsx415.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <16D5B9AB904B0B46B22A27002EE3A8C82793BB@scsmsx415.amr.corp.intel.com>
User-Agent: Mutt/1.4.2.2i
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 23, 2007 at 11:12:22AM -0700, Stone, Joshua I wrote:
> The ability to disable/reenable kprobes would be an interesting
> enhancement.  However, unregister_disabled_kprobes() shouldn't have a
> global effect, because there might be a concurrent kprobes user that
> disabled a probe with the intention of reenabling it later.

enabling/disabling probes sounds like a wonderful additional feature.
I don't think we should expose it as a kernel interface, but rather
through debugfs so I can temporarily disable and then reenable probes
from the shell easily.

