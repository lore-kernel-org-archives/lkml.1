Return-Path: <linux-kernel-owner+w=401wt.eu-S1763500AbYCEHMo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763500AbYCEHMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2008 02:12:44 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752679AbYCEHMe
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Mar 2008 02:12:34 -0500
Received: from el-out-1112.google.com ([209.85.162.181]:57737 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752411AbYCEHMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2008 02:12:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=ZB0FnyEcmfY+fDkxwZhUet/O7LFcsg6ndd8DQZtgLKeHR3+Vc57pg142/i0Ye9NsxmN5eFjLUoMmtlnzYSlFPTJyivPCSXlvP1lyS6/dCpxLQv9YJvhebtuNDTWz8HwmZWAZfe6kTu8IwEHrTLs+ma5iMpx5kBZqnAWDJvZpADI=
Subject: Re: [PATCH] x86: pageattr.c fix shadowed variable warning
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080305070719.GC32434@elte.hu>
References: <1204697127.17484.1.camel@brick>
	 <20080305070719.GC32434@elte.hu>
Content-Type: text/plain
Date: Tue, 04 Mar 2008 23:12:30 -0800
Message-Id: <1204701151.17484.10.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-03-05 at 08:07 +0100, Ingo Molnar wrote:
> * Harvey Harrison <harvey.harrison@gmail.com> wrote:
> 
> > irqs_disabled() uses flags internally, use _flags to avoid shadowing 
> > code calling into this macro.
> 
> thanks Harvey, applied.

Sorry I gave that patch such a poor name...although the warning shows in
pageattr.c, the patch itself is for include/linux/irqflags.h

Harvey

