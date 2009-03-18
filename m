Return-Path: <linux-kernel-owner+w=401wt.eu-S1759189AbZCRTFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759189AbZCRTFv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Mar 2009 15:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753744AbZCRTFm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 18 Mar 2009 15:05:42 -0400
Received: from hera.kernel.org ([140.211.167.34]:60388 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752542AbZCRTFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Mar 2009 15:05:42 -0400
Subject: Re: [tip:tracing/ftrace] tracing: fix oops in
 tracepoint_update_probe_range()
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       jaswinderrajput@gmail.com, fweisbec@gmail.com, rostedt@goodmis.org,
       tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20090318185853.GA16286@elte.hu>
References: <1237394936.3132.1.camel@localhost.localdomain>
	 <tip-966a6fdf6210e3ac8ce00b61cd1107cdf97ce744@git.kernel.org>
	 <1237398997.22438.10.camel@ht.satnam>  <20090318185853.GA16286@elte.hu>
Content-Type: text/plain
Date: Thu, 19 Mar 2009 00:34:28 +0530
Message-Id: <1237403068.22438.19.camel@ht.satnam>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-03-18 at 19:58 +0100, Ingo Molnar wrote:
> It might have worked but it was rather ugly: it took the 
> tracepoints_mutex for no reason.
> 
> The clean fix to skip zero-sized sections early in the function, 
> without taking any lock, and without emitting a warning.
> 

Yes, now it looks better, thanks :-)

--
JSR

