Return-Path: <linux-kernel-owner+w=401wt.eu-S1759280AbYERRVc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759280AbYERRVc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 May 2008 13:21:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752411AbYERRVW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 18 May 2008 13:21:22 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:32871 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752463AbYERRVW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 May 2008 13:21:22 -0400
Date: Sun, 18 May 2008 10:20:41 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       "Andres Salomon" <dilinger@queued.net>,
       "Jens Rottmann" <JRottmann@lippert-at.de>
Subject: Re: [Bug #10649] lxfb driver regression
Message-Id: <20080518102041.54603340.akpm@linux-foundation.org>
In-Reply-To: <7wuznNhcUqC.A.fn.4sBMIB@albercik>
References: <oKKSi1w1qaF.A.mEG.JrBMIB@albercik>
	<7wuznNhcUqC.A.fn.4sBMIB@albercik>
X-Mailer: Sylpheed 2.4.8 (GTK+ 2.12.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 18 May 2008 13:13:55 +0200 (CEST) "Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.25.  Please verify if it still should be listed.
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=10649
> Subject		: lxfb driver regression
> Submitter	: Andres Salomon <dilinger@queued.net>
> Date		: 2008-05-07 21:08 (12 days old)
> References	: http://lkml.org/lkml/2008/5/7/441
> Handled-By	: Jens Rottmann <JRottmann@lippert-at.de>
> Patch		: http://lkml.org/lkml/2008/5/8/207
> 
> 

This was addresed by the now-merged

commit 82f55af06af3d9c478292281ac37b48d2c43741e
Author: Jens Rottmann <JRottmann@LiPPERT-AT.de>
Date:   Wed May 14 16:05:32 2008 -0700

    fix "lxfb: extend PLL table to support dotclocks below 25 MHz"
