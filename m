Return-Path: <linux-kernel-owner+w=401wt.eu-S1758865AbXKBRqS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758865AbXKBRqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2007 13:46:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755731AbXKBRqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Nov 2007 13:46:09 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:43893 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755463AbXKBRqI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2007 13:46:08 -0400
Date: Fri, 2 Nov 2007 10:39:46 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Dave Hansen <haveblue@us.ibm.com>
cc: Andrew Morton <akpm@linux-foundation.org>,
       Pavel Emelyanov <xemul@openvz.org>, Ulrich Drepper <drepper@redhat.com>,
       Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
       "Dinakar Guniguntala [imap]" <dino@in.ibm.com>,
       Sripathi Kodi <sripathik@in.ibm.com>
Subject: Re: [patch] PID namespace design bug, workaround
In-Reply-To: <1194024622.6271.108.camel@localhost>
Message-ID: <alpine.LFD.0.999.0711021038480.3342@woody.linux-foundation.org>
References: <20071101144307.GA29566@elte.hu> <4729E7E4.8070208@openvz.org> 
 <4729E936.4040400@redhat.com> <4729EB3C.9050102@openvz.org> 
 <472A6D91.1020300@redhat.com> <472AD7D6.80900@openvz.org> 
 <20071102010419.23f3db5c.akpm@linux-foundation.org>
 <1194024622.6271.108.camel@localhost>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 2 Nov 2007, Dave Hansen wrote:
> 
> There are certainly more of these, but here is one In the futex
> userspace address, we install the current pid's vnr into a userspace
> address.  

Now, realistically, why not just say "you can't use these things across 
namespaces"? Does anybody really care? After all, somebody who screws this 
up only screws himself, not anybody else.

		Linus
