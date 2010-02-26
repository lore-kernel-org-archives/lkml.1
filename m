Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964873Ab0BZO13 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Feb 2010 09:27:29 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:62006 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964862Ab0BZO12 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Feb 2010 09:27:28 -0500
X-Authority-Analysis: v=1.0 c=1 a=Dc0c8BHHdu8A:10 a=7U3hwN5JcxgA:10 a=F26ntxO4aZN8g-8PDTMA:9 a=bvVWbgY7JJNmjheOc0kA:7 a=St3NF5Bog7MRLoiO-dfO6gOTyE4A:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 03/07] kernel.h string cleanup
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Dave Young <hidave.darkstar@gmail.com>
Cc: Joe Perches <joe@perches.com>, Alexey Dobriyan <adobriyan@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org
In-Reply-To: <a8e1da1002260155l5e75a473oca5649ab33cce124@mail.gmail.com>
References: <20100225155359.GA2722@darkstar> <20100225185515.GB3305@core2>
	 <a8e1da1002251714l55ccbd44ibc1119770667c62b@mail.gmail.com>
	 <b6fcc0a1002252315k1fd5360ehf5ea33566c19515d@mail.gmail.com>
	 <a8e1da1002252333g6e8bf94crba465c59c0cbc07a@mail.gmail.com>
	 <1267170179.12041.4.camel@Joe-Laptop.home>
	 <a8e1da1002260155l5e75a473oca5649ab33cce124@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Fri, 26 Feb 2010 09:27:24 -0500
Message-ID: <1267194445.6328.111.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-02-26 at 17:55 +0800, Dave Young wrote:

> Spliting is necessary from my point of view.

> with the patches applied:
> 
> time:
> real 15m16.504s
> user 12m51.866s
> sys 1m39.700s
> 
> vmlinux .text size: 003bfcd2
> 
> without the patches applied*
> time:
> real 15m20.518s
> user 12m54.120s
> sys 1m40.190s
> 
> vmlinux .text size: 003bfcea

Why the change in text size? If moving stuff around in headers affects
the final result, I'm thinking that you did something wrong.

The merge for x86 did a lot of file manipulation, but Thomas and Ingo
would always test that the binary result was the same. If the binary
result is different, then something went wrong with the file
manipulations.

-- Steve



