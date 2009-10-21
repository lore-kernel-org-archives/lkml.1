Return-Path: <linux-kernel-owner+w=401wt.eu-S1754750AbZJUS1T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750AbZJUS1T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 14:27:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754724AbZJUS1Q
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 14:27:16 -0400
Received: from hofr.at ([212.69.189.236]:49888 "EHLO mail.hofr.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719AbZJUS1O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 14:27:14 -0400
X-Greylist: delayed 612 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Oct 2009 14:27:14 EDT
Date: Wed, 21 Oct 2009 20:17:05 +0200
From: Nicholas Mc Guire <der.herr@hofr.at>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Daney <ddaney@caviumnetworks.com>,
       Wu Zhangjin <wuzhangjin@gmail.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Thomas Gleixner <tglx@linutronix.de>,
       Ralf Baechle <ralf@linux-mips.org>
Subject: Re: [PATCH -v4 9/9] tracing: add function graph tracer support for
	MIPS
Message-ID: <20091021181705.GA5218@opentech.at>
References: <af3ec1b5cd06b6f6a461c9fa7d09a51fabccb08d.1256135456.git.wuzhangjin@gmail.com> <a6f2959a69b6a77dd32cc36a5c8202f97d524f1e.1256135456.git.wuzhangjin@gmail.com> <53bdfdd95ec4fa00d4cc505bb5972cf21243a14d.1256135456.git.wuzhangjin@gmail.com> <1256141540.18347.3118.camel@gandalf.stny.rr.com> <4ADF38D5.9060100@caviumnetworks.com> <1256143568.18347.3169.camel@gandalf.stny.rr.com> <4ADF3FE0.5090104@caviumnetworks.com> <1256145813.18347.3210.camel@gandalf.stny.rr.com> <4ADF4982.9010306@caviumnetworks.com> <1256148562.18347.3264.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1256148562.18347.3264.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> 
> 
> We're not doing back traces. We need to modify the return of the
> function being called. Note, the above functions that end with ";" are
> leaf functions. Non leaf functions show "{" and end with "}".
> 
> The trick here is to find a reliable way to modify the return address.
>
would it not more or less be the same thing if you used -finstrument-functions
then and provide a stub __cyg_profile_func_enter/exit initialized to an empty
function until you replace it during tracing. This does give you an overhead
when you are not tracing - but it would make the tracer implementation quite
generic.

hofrat 
