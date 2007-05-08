Return-Path: <linux-kernel-owner+w=401wt.eu-S934686AbXEHPpt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934686AbXEHPpt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2007 11:45:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934590AbXEHPpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 8 May 2007 11:45:25 -0400
Received: from e36.co.us.ibm.com ([32.97.110.154]:60392 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754257AbXEHPeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2007 11:34:06 -0400
Message-ID: <46409865.9010204@linux.vnet.ibm.com>
Date: Tue, 08 May 2007 10:33:57 -0500
From: Brian King <brking@linux.vnet.ibm.com>
Reply-To: brking@linux.vnet.ibm.com
User-Agent: Thunderbird 1.5.0.10 (X11/20060911)
MIME-Version: 1.0
To: Jeff Garzik <jeff@garzik.org>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-ide@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
       James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [git patches] libata reset sequence update
References: <20070508063820.GA13469@havoc.gtf.org>
In-Reply-To: <20070508063820.GA13469@havoc.gtf.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik wrote:
> This has been testing in -mm for a while, but I wanted to send it
> separated from the main libata update, since it has a chance of
> breakage.
> 
> Most notably, a cumulative timeout (deadline) helps the code from diving
> into overly-long reset sequences.
> 
> Please pull from 'reset-seq' branch of
> master.kernel.org:/pub/scm/linux/kernel/git/jgarzik/libata-dev.git reset-seq

James,

FYI - this means you'll probably want to revert this patch:

http://git.kernel.org/gitweb.cgi?p=linux/kernel/git/jejb/scsi-misc-2.6.git;a=commitdiff;h=a6506b8e111c9bf9e430e32725b96c0688416c8e

-Brian

