Return-Path: <linux-kernel-owner+w=401wt.eu-S1756864AbZABCcQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756864AbZABCcQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jan 2009 21:32:16 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755550AbZABCcA
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 1 Jan 2009 21:32:00 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34394 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755483AbZABCcA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jan 2009 21:32:00 -0500
Date: Thu, 1 Jan 2009 18:31:57 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Valdis.Kletnieks@vt.edu
Cc: linux-kernel@vger.kernel.org
Subject: Re: mmotm 2008-12-30-16-05 uploaded
Message-Id: <20090101183157.dfbe9789.akpm@linux-foundation.org>
In-Reply-To: <22921.1230843108@turing-police.cc.vt.edu>
References: <200812310006.mBV060iV029753@imap1.linux-foundation.org>
	<22921.1230843108@turing-police.cc.vt.edu>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 01 Jan 2009 15:51:48 -0500 Valdis.Kletnieks@vt.edu wrote:

> On Tue, 30 Dec 2008 16:06:00 PST, akpm@linux-foundation.org said:
> > The mm-of-the-moment snapshot 2008-12-30-16-05 has been uploaded to
> 
> 
>   CC =5BM=5D  drivers/misc/dell-laptop.o
> drivers/misc/dell-laptop.c: In function dell_send_request:
> drivers/misc/dell-laptop.c:147: error: implicit declaration of function dcdbas_smi_request
> 
> Fix: move misc-add-dell-laptop-driver.patch to someplace below
> dcdbas-export-functionality-for-use-in-other-drivers.patch in the series file.
> 

OK, thanks, done.

Confused.  I assume you were doing a bisection.
