Return-Path: <linux-kernel-owner+w=401wt.eu-S933217AbXCVPbR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933217AbXCVPbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2007 11:31:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933192AbXCVPbR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 22 Mar 2007 11:31:17 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:53153 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933217AbXCVPbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2007 11:31:16 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Ian Kent <raven@themaw.net>
Cc: Herbert Poetzl <herbert@13thfloor.at>,
       "Serge E. Hallyn" <serue@us.ibm.com>, Cedric Le Goater <clg@fr.ibm.com>,
       sukadev@us.ibm.com, Andrew Morton <akpm@osdl.org>,
       Dave Hansen <haveblue@us.ibm.com>, containers@lists.osdl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] Replace pid_t in autofs with struct pid reference
References: <1174063618.3397.58.camel@raven.themaw.net>
	<m1hcslm1tc.fsf@ebiederm.dsl.xmission.com>
	<20070319200839.GB19449@sergelap.austin.ibm.com>
	<m1odmpvuft.fsf@ebiederm.dsl.xmission.com>
	<20070320201548.GA21312@sergelap.austin.ibm.com>
	<m17itbmypc.fsf@ebiederm.dsl.xmission.com>
	<20070320214125.GA5585@sergelap.austin.ibm.com>
	<m1r6rjlgl9.fsf@ebiederm.dsl.xmission.com>
	<20070321205834.GB21517@sergelap.austin.ibm.com>
	<1174530523.4635.25.camel@raven.themaw.net>
	<20070322143312.GA17784@MAIL.13thfloor.at>
	<1174575837.4635.68.camel@raven.themaw.net>
Date: Thu, 22 Mar 2007 09:29:37 -0600
In-Reply-To: <1174575837.4635.68.camel@raven.themaw.net> (Ian Kent's message
	of "Fri, 23 Mar 2007 00:03:57 +0900")
Message-ID: <m13b3x8ffi.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ian Kent <raven@themaw.net> writes:

> btw please don't be confused by my use of "user space application". In
> my comments I'm talking about applications that are similar in function
> to autofs itself and not processes that might trigger mounts. For
> example the "autodir" package uses the autofs filesystem to provide
> dynamic home directory creation. The point being that we can't know what
> an application may do with the info in a request packet so we need to be
> sure we cover all the cases.

A sentiment I share, and the reason why it is taking so long to come
up with a patch for autofs4 that passes review.

Eric
