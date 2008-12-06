Return-Path: <linux-kernel-owner+w=401wt.eu-S1757601AbYLFMkq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757601AbYLFMkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2008 07:40:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755522AbYLFMkj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 6 Dec 2008 07:40:39 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:57190 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331AbYLFMki (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2008 07:40:38 -0500
Date: Sat, 6 Dec 2008 12:40:31 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Parav Pandit <paravpandit@yahoo.com>
Cc: Linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: mechanism to syncronise device access from user and kernel
Message-ID: <20081206124031.GB4821@srcf.ucam.org>
References: <377462.57009.qm@web30107.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <377462.57009.qm@web30107.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.12-2006-07-14
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@codon.org.uk
X-SA-Exim-Scanned: No (on vavatch.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 05, 2008 at 10:28:27AM -0800, Parav Pandit wrote:
> Hi,
> 
> I have a device whose registers are accessed by driver as well as user space application via mmap() area.
> 
> How to synchronize the access (avoid race condition) between user space driver and kernel mode driver, in single CPU and multi-CPU systems?

Rewrite userspace to use the kernel driver?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
