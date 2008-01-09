Return-Path: <linux-kernel-owner+w=401wt.eu-S1756829AbYAIADU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756829AbYAIADU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2008 19:03:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751779AbYAIADM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 Jan 2008 19:03:12 -0500
Received: from relay1.sgi.com ([192.48.171.29]:46679 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751667AbYAIADL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2008 19:03:11 -0500
Date: Tue, 8 Jan 2008 18:03:09 -0600
From: Paul Jackson <pj@sgi.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: jbeulich@novell.com, hch@infradead.org, pagg@oss.sgi.com, erikj@sgi.com,
       matthltc@us.ibm.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] add task handling notifier
Message-Id: <20080108180309.4ccab28d.pj@sgi.com>
In-Reply-To: <20080108141424.de5d8fba.akpm@linux-foundation.org>
References: <476A780C.76E4.0078.0@novell.com>
	<20071223122621.GA19310@infradead.org>
	<20071225140526.547a882f.akpm@linux-foundation.org>
	<47838ACB.76E4.0078.0@novell.com>
	<20080108141424.de5d8fba.akpm@linux-foundation.org>
Organization: SGI
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.12.0; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew wrote:
> What are those (unidentified) add-on features doing at present?
> Patching calls into fork.c/exec.c/exit.c?

Most likely.  I suspect we have general agreement and awareness
that such patching is not something that sells well in Linux-land.
And for good reason in my personal view ... such patching by loadable
modules could open the door to compromising the integrity of Linux in
ways that could be dangerous.

-- 
                  I won't rest till it's the best ...
                  Programmer, Linux Scalability
                  Paul Jackson <pj@sgi.com> 1.940.382.4214
