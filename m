Return-Path: <linux-kernel-owner+w=401wt.eu-S932303AbXGKLm5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932303AbXGKLm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2007 07:42:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760764AbXGKLmt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jul 2007 07:42:49 -0400
Received: from netops-testserver-4-out.sgi.com ([192.48.171.29]:40602 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755641AbXGKLms (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2007 07:42:48 -0400
Date: Wed, 11 Jul 2007 04:42:44 -0700
From: Paul Jackson <pj@sgi.com>
To: vatsa@linux.vnet.ibm.com
Cc: mingo@elte.hu, containers@lists.osdl.org, menage@google.com,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: containers (was Re: -mm merge plans for 2.6.23)
Message-Id: <20070711044244.c0916fe5.pj@sgi.com>
In-Reply-To: <20070711113953.GB23473@linux.vnet.ibm.com>
References: <20070710013152.ef2cd200.akpm@linux-foundation.org>
	<20070710105240.GA20914@linux.vnet.ibm.com>
	<6599ad830707101134k29951c45h4af0807603f52b76@mail.gmail.com>
	<20070710115319.0bdaff34.akpm@linux-foundation.org>
	<20070711045516.GH2927@linux.vnet.ibm.com>
	<20070710222942.382fc9ba.akpm@linux-foundation.org>
	<20070711090423.GA6758@elte.hu>
	<20070711022352.71604404.pj@sgi.com>
	<20070711100323.GA23473@linux.vnet.ibm.com>
	<20070711101958.GA10095@elte.hu>
	<20070711113953.GB23473@linux.vnet.ibm.com>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.3; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Srivatsa wrote:
> The fact that we will have two interface for group scheduler in 2.6.24
> is what worries me a bit (one user-id based and other container based).

Yeah.

One -could- take linear combinations, as Peter drew in his ascii art,
but would one -want- to do that?

I imagine some future time, when users of this wonder why the API is
more complicated than seems necessary, with two factors determining
task-groups where one seems sufficient, and the answer is "the other
factor, user-id's, is just there because we needed it as an interim
mechanism, and then had to keep it, to preserve ongoing compatibility.
That's not a very persuasive justification.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.925.600.0401
