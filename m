Return-Path: <linux-kernel-owner+w=401wt.eu-S1755985AbZJVR7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755985AbZJVR7U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 13:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754220AbZJVR7T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 13:59:19 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:44557 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752180AbZJVR7S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 13:59:18 -0400
Subject: Re: [PATCH -v4 4/9] tracing: add static function tracer support
 for MIPS
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: wuzhangjin@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
In-Reply-To: <1256233679.23653.7.camel@falcon>
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
	 <3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>
	 <ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>
	 <1256138686.18347.3039.camel@gandalf.stny.rr.com>
	 <1256233679.23653.7.camel@falcon>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Thu, 22 Oct 2009 13:59:21 -0400
Message-Id: <1256234361.20866.796.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-10-23 at 01:47 +0800, Wu Zhangjin wrote:
> On Wed, 2009-10-21 at 11:24 -0400, Steven Rostedt wrote:

> > Is t0 and t1 safe for mcount to use? Remember, mcount does not follow
> > the dynamics of C function ABI.
> 
> So, perhaps we can use the saved registers(a0,a1...) instead.

I don't know. I was just asking.

-- Steve


