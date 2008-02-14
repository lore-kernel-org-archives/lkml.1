Return-Path: <linux-kernel-owner+w=401wt.eu-S1760082AbYBNOA2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760082AbYBNOA2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2008 09:00:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753158AbYBNOAM
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 14 Feb 2008 09:00:12 -0500
Received: from nat-132.atmel.no ([80.232.32.132]:61164 "EHLO relay.atmel.no"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752496AbYBNOAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2008 09:00:10 -0500
Date: Thu, 14 Feb 2008 15:00:05 +0100
From: Haavard Skinnemoen <hskinnemoen@atmel.com>
To: Pierre Ossman <drzeus-list@drzeus.cx>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: MMC core debugfs support (was Re: [RFC v2 5/5] Atmel MCI: Driver
 for Atmel on-chip MMC controllers)
Message-ID: <20080214150005.2c46a991@dhcp-252-066.norway.atmel.com>
In-Reply-To: <20080213193051.1a7e3b29@poseidon.drzeus.cx>
References: <1201630213-31900-1-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-2-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-3-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-4-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-5-git-send-email-hskinnemoen@atmel.com>
	<1201630213-31900-6-git-send-email-hskinnemoen@atmel.com>
	<20080213193051.1a7e3b29@poseidon.drzeus.cx>
Organization: Atmel Norway
X-Mailer: Claws Mail 3.2.0 (GTK+ 2.12.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[removing lots of people from Cc]

On Wed, 13 Feb 2008 19:30:51 +0100
Pierre Ossman <drzeus-list@drzeus.cx> wrote:

> > +static int req_dbg_open(struct inode *inode, struct file *file)
> > +{  
> 
> And this should go into the core.

I've started working on this, but I've run into a problem: The mmc core
structures don't seem to keep any references to the current request. So
I don't really have any information to put into the 'req' file after
moving it into the core.

Any ideas on how to solve this?

Haavard
