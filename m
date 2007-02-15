Return-Path: <linux-kernel-owner+w=401wt.eu-S932140AbXBOEGE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932140AbXBOEGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 23:06:04 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932151AbXBOEGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 23:06:04 -0500
Received: from ozlabs.org ([203.10.76.45]:40906 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932140AbXBOEGD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 23:06:03 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <17875.56356.396676.239952@cargo.ozlabs.ibm.com>
Date: Thu, 15 Feb 2007 15:05:56 +1100
From: Paul Mackerras <paulus@samba.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: minyard@acm.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 4/4] ipmi: add new IPMI nmi watchdog handling
In-Reply-To: <20070214195718.e78458cf.akpm@linux-foundation.org>
References: <20070214201257.GD5364@localdomain>
	<20070214195718.e78458cf.akpm@linux-foundation.org>
X-Mailer: VM 7.19 under Emacs 21.4.1
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Andrew Morton writes:

> This is all fairly unpleasant.
> 
> What architecture is preventing us from using DIE_NMI_POST on all
> architectures which support ipmi?  ia64?
> 
> It would be better to simply require that all ipmi-using architectures
> implement notify_die(DIE_NMI_POST, ...).

We're starting to see IPMI creeping on powerpc as well, and we don't
have an NMI.

Paul.
