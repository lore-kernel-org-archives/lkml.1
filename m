Return-Path: <linux-kernel-owner+w=401wt.eu-S1760836AbXE1Q2b@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760836AbXE1Q2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2007 12:28:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754654AbXE1Q2Z
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 28 May 2007 12:28:25 -0400
Received: from paris.bmts.com ([216.183.128.227]:51781 "EHLO paris.bmts.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753738AbXE1Q2Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2007 12:28:24 -0400
Date: Mon, 28 May 2007 12:28:17 -0400
From: Mike Houston <mikeserv@bmts.com>
To: "Michal Piotrowski" <michal.k.k.piotrowski@gmail.com>
Cc: linux-kernel@vger.kernel.org, zach@vmware.com
Subject: Re: 2.6.22-rc3 - VMI does not compile unless himem enabled
Message-Id: <20070528122817.86079676.mikeserv@bmts.com>
In-Reply-To: <6bffcb0e0705280311i6946f444l36465357ed7850ab@mail.gmail.com>
References: <20070527054746.632f06f8.mikeserv@bmts.com>
	<6bffcb0e0705280311i6946f444l36465357ed7850ab@mail.gmail.com>
X-Mailer: Sylpheed version 2.2.10 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-brucetelecom.com-MailScanner-Information: Please contact Bruce Telecom 519.368.2000 for more information
X-brucetelecom.com-MailScanner: Found to be clean
X-brucetelecom.com-MailScanner-From: mikeserv@bmts.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 May 2007 12:11:35 +0200
"Michal Piotrowski" <michal.k.k.piotrowski@gmail.com> wrote:

> Hi Mike,
> 
> On 27/05/07, Mike Houston <mikeserv@bmts.com> wrote:
> > While building kernels for vmware guests, I noticed that the
> > paravirt VMI driver in 2.6.22-rc3 does not compile when highmem
> > support is disabled. This did not occur in 2.6.21

> Please try this patch
> http://lkml.org/lkml/diff/2007/5/24/143/1

Thank you Michal, Alexey Dobriyan replied off list and
showed me the fix that already went into -mm and it did indeed solve
the problem and the paravirt in the vmware guests works fine. Nice of
you folks to help me when I missed the ball. Sorry for missing that.

Mike Houston
