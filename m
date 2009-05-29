Return-Path: <linux-kernel-owner+w=401wt.eu-S1761831AbZE2TtF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761831AbZE2TtF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 May 2009 15:49:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1761040AbZE2Tsx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 May 2009 15:48:53 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36422 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760499AbZE2Tsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 May 2009 15:48:53 -0400
Date: Fri, 29 May 2009 12:48:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net>
Cc: jens.axboe@oracle.com, andrew.patterson@hp.com,
       linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
       scameron@beardog.cca.cpqcorp.net
Subject: Re: [PATCH v6] cciss: add cciss driver sysfs entries
Message-Id: <20090529124813.689b7667.akpm@linux-foundation.org>
In-Reply-To: <20090528202124.GB4846@beardog.cca.cpqcorp.net>
References: <20090413164524.17977.99322.stgit@bluto.andrew>
	<20090413164530.17977.32550.stgit@bluto.andrew>
	<20090528202124.GB4846@beardog.cca.cpqcorp.net>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 May 2009 15:21:24 -0500
"Mike Miller (OS Dev)" <mikem@beardog.cca.cpqcorp.net> wrote:

> From: Andrew Patterson <andrew.patterson@hp.com>
> 
> This patch adds sysfs entries to the cciss driver needed for the
> dm/multipath tools. A file for vendor, model, rev, and unique_id is
> added for each logical drive under directory
> /sys/bus/pci/devices/<dev>/ccissX/cXdY. Where X = the controller (or
> host) number and Y is the logical drive number. A link from
> /sys/bus/pci/devices/<dev>/ccissX/cXdY/block:cciss!cXdY to
> /sys/block/cciss!cXdY/device is also created. A bus is created
> in /sys/bus/cciss.  A link is created from the pci ccissX entry to
> /sys/bus/cciss/devices/ccissX.
> Please consider this for inclusion.
> 
> Signed-off-by: Mike Miller <mike.miller@hp.com>

Did Andrew's signed-off-by: get lost?
