Return-Path: <linux-kernel-owner+w=401wt.eu-S1762267AbZLKCuZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762267AbZLKCuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Dec 2009 21:50:25 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1762225AbZLKCuZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Dec 2009 21:50:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:62251 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762197AbZLKCuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Dec 2009 21:50:24 -0500
X-Authority-Analysis: v=1.0 c=1 a=aH5DXaW3jXgA:10 a=7U3hwN5JcxgA:10 a=Xu_aML22AAAA:8 a=k93riptPOP-vjxGzZkoA:9 a=mUU1_EjqX81UgPQhmQ_IWb6brqcA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 0/4] ftrace - Add function duration tracer to ftrace
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Tim Bird <tim.bird@am.sony.com>
Cc: "Bird, Tim" <Timothy.Bird@am.sony.com>,
       linux kernel <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Frederic Weisbecker <fweisbec@gmail.com>
In-Reply-To: <4B21584B.6010405@am.sony.com>
References: <4B202753.4010108@am.sony.com>
	 <1260416495.2146.130.camel@gandalf.stny.rr.com>
	 <4B21584B.6010405@am.sony.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Thu, 10 Dec 2009 21:50:29 -0500
Message-ID: <1260499829.2146.328.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2009-12-10 at 12:21 -0800, Tim Bird wrote:

> It may be moot, given the ensuing discussion (which I'll respond to
> shortly), but here's a link to an uncorrupted version:
> 
> http://elinux.org/images/3/3e/Measuring-function-duration-with-ftrace-october-2009.pdf

I just read your presentation, and I like it :-)

I still feel that we don't want to add another plugin, but as I also
stated, I don't want to stop improving on the current plugins until we
have a better alternative.

Would it be possible in making this an trace option (for now). And then
the function graph tracer would just morph into this duration tracer. No
added plugin, but just an option.

I do see value in this, and I don't want to keep it from making it into
34 just because we plan to some day phase out the plugins. There's too
many times we try to go for broke and end up with nothing at the end.
This is why it took so long for streamline_config to make it in.

Just make any tools that interface with this flexible, (abstract layer)
so that if this does change the tools can cope.

-- Steve


