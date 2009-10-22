Return-Path: <linux-kernel-owner+w=401wt.eu-S1756377AbZJVSef@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756377AbZJVSef (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Oct 2009 14:34:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753202AbZJVSef
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Oct 2009 14:34:35 -0400
Received: from mail-fx0-f218.google.com ([209.85.220.218]:53151 "EHLO
	mail-fx0-f218.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbZJVSee (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Oct 2009 14:34:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :organization:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=cqtKytet/LF5v3JaLbDCFq/aDE5YLaDVeIIg7uigKZSG72jLirmRlUiP8PqCTmg+Lp
         EVecVi/A8DVJhBiWhvHJQ8qtKWJkJ5JWo7jT0/8pOGFUNviLNp2eAVy7aoJAa0scG7+j
         v86yibQKeZrsPP2qST1AwOsmGPFsWwxTusSmI=
Subject: Re: [PATCH -v4 4/9] tracing: add static function tracer support
 for MIPS
From: Wu Zhangjin <wuzhangjin@gmail.com>
Reply-To: wuzhangjin@gmail.com
To: rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
       Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>,
       Nicholas Mc Guire <der.herr@hofr.at>
In-Reply-To: <1256234361.20866.796.camel@gandalf.stny.rr.com>
References: <028867b99ec532b84963a35e7d552becc783cafc.1256135456.git.wuzhangjin@gmail.com>
	 <2f73eae542c47ac5bbb9f7280e6c0271d193e90d.1256135456.git.wuzhangjin@gmail.com>
	 <3f0d3515f74a58f4cfd11e61b62a129fdc21e3a7.1256135456.git.wuzhangjin@gmail.com>
	 <ea8aa927fbd184b54941e4c2ae0be8ea0b4f6b8a.1256135456.git.wuzhangjin@gmail.com>
	 <1256138686.18347.3039.camel@gandalf.stny.rr.com>
	 <1256233679.23653.7.camel@falcon>
	 <1256234361.20866.796.camel@gandalf.stny.rr.com>
Content-Type: text/plain
Organization: DSLab, Lanzhou University, China
Date: Fri, 23 Oct 2009 02:34:29 +0800
Message-Id: <1256236469.23653.12.camel@falcon>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-10-22 at 13:59 -0400, Steven Rostedt wrote:
> On Fri, 2009-10-23 at 01:47 +0800, Wu Zhangjin wrote:
> > On Wed, 2009-10-21 at 11:24 -0400, Steven Rostedt wrote:
> 
> > > Is t0 and t1 safe for mcount to use? Remember, mcount does not follow
> > > the dynamics of C function ABI.
> > 
> > So, perhaps we can use the saved registers(a0,a1...) instead.
> 
> I don't know. I was just asking.

I just used a0,a1,a2 instead of t0,t1,t2, we are safe to use them for
they have been saved/restored.

Thanks!

