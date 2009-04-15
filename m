Return-Path: <linux-kernel-owner+w=401wt.eu-S1756218AbZDOWcV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756218AbZDOWcV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Apr 2009 18:32:21 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752336AbZDOWcI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Apr 2009 18:32:08 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47126 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752104AbZDOWcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Apr 2009 18:32:06 -0400
Date: Wed, 15 Apr 2009 15:27:04 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Harry Ciao <qingtao.cao@windriver.com>
Cc: norsk5@yahoo.com, michael@ellerman.id.au,
       bluesmoke-devel@lists.sourceforge.net, linuxppc-dev@ozlabs.org,
       linux-kernel@vger.kernel.org
Subject: Re: [v2 PATCH 1/3] EDAC: Add CPC925 Memory Controller driver
Message-Id: <20090415152704.b7ebddc7.akpm@linux-foundation.org>
In-Reply-To: <1239602716-18352-2-git-send-email-qingtao.cao@windriver.com>
References: <1239602716-18352-1-git-send-email-qingtao.cao@windriver.com>
	<1239602716-18352-2-git-send-email-qingtao.cao@windriver.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Apr 2009 14:05:14 +0800
Harry Ciao <qingtao.cao@windriver.com> wrote:

> Introduce IBM CPC925 EDAC driver, which makes use of ECC, CPU and
> HyperTransport Link error detections and corrections on the IBM
> CPC925 Bridge and Memory Controller.

A wee cleanup:

--- a/drivers/edac/cpc925_edac.c~edac-add-cpc925-memory-controller-driver-cleanup
+++ a/drivers/edac/cpc925_edac.c
@@ -291,9 +291,6 @@ struct cpc925_dev_info {
 	void (*check)(struct edac_device_ctl_info *edac_dev);
 };
 
-
-static int edac_mc_idx;
-
 /* Get total memory size from Open Firmware DTB */
 static void get_total_mem(struct cpc925_mc_pdata *pdata)
 {
@@ -866,6 +863,7 @@ static int cpc925_mc_get_channels(void _
 
 static int __devinit cpc925_probe(struct platform_device *pdev)
 {
+	static int edac_mc_idx;
 	struct mem_ctl_info *mci;
 	void __iomem *vbase;
 	struct cpc925_mc_pdata *pdata;
_

