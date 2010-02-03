Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932682Ab0BCRWH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Feb 2010 12:22:07 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:37084 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932622Ab0BCRWB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Feb 2010 12:22:01 -0500
X-Authority-Analysis: v=1.0 c=1 a=KJe5iWfhaysA:10 a=7U3hwN5JcxgA:10 a=_1jtTQaichL4LKB2glQA:9 a=fNPTFbr0wvi3pJWxjwuvrp2JIbIA:4
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 2/3] trace-cmd: fix printf compile warnings
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Darren Hart <dvhltc@us.ibm.com>
Cc: John Kacur <jkacur@redhat.com>, linux-kernel@vger.kernel.org
In-Reply-To: <4B69AE88.7080705@us.ibm.com>
References: <1265043026-24987-1-git-send-email-dvhltc@us.ibm.com>
	 <1265043026-24987-3-git-send-email-dvhltc@us.ibm.com>
	 <520f0cf11002030807t48678b82ye56624840e6f9ce3@mail.gmail.com>
	 <1265214665.24386.3.camel@gandalf.stny.rr.com>
	 <4B69AE88.7080705@us.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
Organization: Kihon Technologies Inc.
Date: Wed, 03 Feb 2010 12:21:56 -0500
Message-ID: <1265217716.24386.9.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-02-03 at 09:12 -0800, Darren Hart wrote:

> > Of the three patches, I think this is the only one that is correct ;-)
> 
> The other appear to depend on the guint arch specific implementation of 
> the guint64 type, so the only way to fix it with a cast to ull - or to 
> not use g types at all. Bleh.

I'm fixing it up by typecasting it to (u64), and defining it.

I probably should never have used guint64 but since that's the "glib"
thing to do, and when in Rome do as the Romans do, even if the Romans
are doing crap!

-- Steve



