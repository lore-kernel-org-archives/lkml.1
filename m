Return-Path: <linux-kernel-owner+w=401wt.eu-S964898AbXBOEQi@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964898AbXBOEQi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Feb 2007 23:16:38 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932629AbXBOEQi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 14 Feb 2007 23:16:38 -0500
Received: from smtp.osdl.org ([65.172.181.24]:33748 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932618AbXBOEQh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Feb 2007 23:16:37 -0500
Date: Wed, 14 Feb 2007 20:16:32 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Paul Mackerras <paulus@samba.org>
Cc: minyard@acm.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [patch 4/4] ipmi: add new IPMI nmi watchdog handling
Message-Id: <20070214201632.a7f18794.akpm@linux-foundation.org>
In-Reply-To: <17875.56356.396676.239952@cargo.ozlabs.ibm.com>
References: <20070214201257.GD5364@localdomain>
	<20070214195718.e78458cf.akpm@linux-foundation.org>
	<17875.56356.396676.239952@cargo.ozlabs.ibm.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Feb 2007 15:05:56 +1100 Paul Mackerras <paulus@samba.org> wrote:

> Andrew Morton writes:
> 
> > This is all fairly unpleasant.
> > 
> > What architecture is preventing us from using DIE_NMI_POST on all
> > architectures which support ipmi?  ia64?
> > 
> > It would be better to simply require that all ipmi-using architectures
> > implement notify_die(DIE_NMI_POST, ...).
> 
> We're starting to see IPMI creeping on powerpc as well, and we don't
> have an NMI.
> 

Sure, but you could implement the registration function.  I mean, you
_would_ call the NMI callback if you could, right ;)

As it stands, this change is pretty gruesome...
