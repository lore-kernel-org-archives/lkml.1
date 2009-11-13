Return-Path: <linux-kernel-owner+w=401wt.eu-S932432AbZKMWyL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932432AbZKMWyL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Nov 2009 17:54:11 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932339AbZKMWyJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 13 Nov 2009 17:54:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15595 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932316AbZKMWyI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Nov 2009 17:54:08 -0500
Date: Fri, 13 Nov 2009 17:52:14 -0500
From: Dave Jones <davej@redhat.com>
To: Roland Dreier <rdreier@cisco.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Mike Travis <travis@sgi.com>,
       Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Heiko Carstens <heiko.carstens@de.ibm.com>,
       Randy Dunlap <rdunlap@xenotime.net>, Tejun Heo <tj@kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, Yinghai Lu <yinghai@kernel.org>,
       David Rientjes <rientjes@google.com>,
       Steven Rostedt <rostedt@goodmis.org>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
       Jack Steiner <steiner@sgi.com>,
       Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
       Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86: Remove CPU cache size output for non-Intel too
Message-ID: <20091113225214.GA21609@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Roland Dreier <rdreier@cisco.com>, "H. Peter Anvin" <hpa@zytor.com>,
	Mike Travis <travis@sgi.com>, Andi Kleen <ak@linux.intel.com>,
	Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Heiko Carstens <heiko.carstens@de.ibm.com>,
	Randy Dunlap <rdunlap@xenotime.net>, Tejun Heo <tj@kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Yinghai Lu <yinghai@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Rusty Russell <rusty@rustcorp.com.au>,
	Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
	Jack Steiner <steiner@sgi.com>,
	Frederic Weisbecker <fweisbec@gmail.com>, x86@kernel.org,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <87tyxmy6x6.fsf@basil.nowhere.org>
 <4AE5E48F.6020408@sgi.com>
 <20091026215544.GA3355@basil.fritz.box>
 <4AEB3D95.50300@sgi.com>
 <4AEEBE65.3070202@linux.intel.com>
 <4AEF3143.2030701@sgi.com>
 <20091112222200.GA19109@redhat.com>
 <4AFC92DD.3020105@zytor.com>
 <20091112231542.GA7129@redhat.com>
 <adaocn6dp99.fsf_-_@roland-alpha.cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <adaocn6dp99.fsf_-_@roland-alpha.cisco.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 13, 2009 at 02:38:26PM -0800, Roland Dreier wrote:
 > As Dave Jones said about the output in intel_cacheinfo.c: "They aren't
 > useful, and pollute the dmesg output a lot (especially on machines with
 > many cores).  Also the same information can be trivially found out from
 > userspace."  Give the generic display_cacheinfo() function the same
 > treatment.
 > 
 > Signed-off-by: Roland Dreier <rolandd@cisco.com>

Acked-by: Dave Jones <davej@redhat.com>


