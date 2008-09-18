Return-Path: <linux-kernel-owner+w=401wt.eu-S1756190AbYIRIrx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756190AbYIRIrx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 04:47:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753446AbYIRIro
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 04:47:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54101 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753410AbYIRIrn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 04:47:43 -0400
Date: Thu, 18 Sep 2008 01:47:33 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Martin Knoblauch <knobi@knobisoft.de>
Cc: Greg Banks <gnb@melbourne.sgi.com>,
       linux-nfs list <linux-nfs@vger.kernel.org>,
       linux-kernel@vger.kernel.org, Peter zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [RFC][Resend] Make NFS-Client readahead tunable
Message-Id: <20080918014733.3c9c362e.akpm@linux-foundation.org>
In-Reply-To: <124712.40022.qm@web32602.mail.mud.yahoo.com>
References: <124712.40022.qm@web32602.mail.mud.yahoo.com>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Sep 2008 01:38:57 -0700 (PDT) Martin Knoblauch <knobi@knobisoft.de> wrote:

> > No.  mount(8) will pass unrecognised options straight down into the
> > filesystem driver.
> >
> 
>  Has that always been the case, or is it a recent change? I have to support RHEL4 userland, which is not really new.

It's been that way for ever and ever.  It's how all these guys:

y:/usr/src/25> grep Opt_ fs/*/super.c|wc
    781    2626   33703

get handled.
