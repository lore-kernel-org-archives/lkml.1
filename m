Return-Path: <linux-kernel-owner+w=401wt.eu-S1755443AbZBDK7T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755443AbZBDK7T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Feb 2009 05:59:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751341AbZBDK7J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Feb 2009 05:59:09 -0500
Received: from ozlabs.org ([203.10.76.45]:57167 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751322AbZBDK7G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Feb 2009 05:59:06 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: Anders Kaseorg <andersk@mit.edu>
Subject: Re: [PATCH 2/7] x86: Add an option to compile with -ffunction-sections -fdata-sections
Date: Wed, 4 Feb 2009 21:28:58 +1030
User-Agent: KMail/1.11.0 (Linux/2.6.27-11-generic; KDE/4.2.0; i686; ; )
Cc: Jeff Arnold <jbarnold@mit.edu>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org, Denys Vlasenko <vda.linux@googlemail.com>,
       Tim Abbott <tabbott@mit.edu>, Waseem Daher <wdaher@mit.edu>,
       Nikanth Karthikesan <knikanth@suse.de>
References: <1228521840-3886-1-git-send-email-jbarnold@mit.edu> <200902041908.42173.rusty@rustcorp.com.au> <alpine.DEB.2.00.0902040453590.32142@vinegar-pot.mit.edu>
In-Reply-To: <alpine.DEB.2.00.0902040453590.32142@vinegar-pot.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200902042128.59009.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 February 2009 20:56:04 Anders Kaseorg wrote:
> The conflict is that FUNCTION_TRACER enables KBUILD_CFLAGS += -pg, and 
> passing -pg to current gcc causes it to emit a warning and disable 
> -ffunction-sections:
>   <http://gcc.gnu.org/ml/gcc-help/2008-11/msg00128.html>

Ah, OK, this explanation should probably be in a paragraph in the Kconfig
help message, rather than hiding on lkml.

Otherwise, updated looks good.

Thanks,
Rusty.
