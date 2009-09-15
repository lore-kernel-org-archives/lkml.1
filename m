Return-Path: <linux-kernel-owner+w=401wt.eu-S1758376AbZIOTlz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758376AbZIOTlz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Sep 2009 15:41:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758000AbZIOTlu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Sep 2009 15:41:50 -0400
Received: from fifo99.com ([67.223.236.141]:45077 "EHLO fifo99.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755274AbZIOTlt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Sep 2009 15:41:49 -0400
Subject: Re: [PATCH 06/20] mem_class: use minor as index instead of
 searching the array
From: Daniel Walker <dwalker@fifo99.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>
In-Reply-To: <1253041976-1111-6-git-send-email-gregkh@suse.de>
References: <20090915181247.GA32167@kroah.com>
	 <1253041976-1111-6-git-send-email-gregkh@suse.de>
Content-Type: text/plain
Date: Tue, 15 Sep 2009 12:42:43 -0700
Message-Id: <1253043763.11643.358.camel@desktop>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-09-15 at 12:12 -0700, Greg Kroah-Hartman wrote:
> +static const struct memdev {
> +       const char *name;
> +       const struct file_operations *fops;
> +       struct backing_dev_info *dev_info;
> +} devlist[] = {
> +       [ 1] = { "mem", &mem_fops, &directly_mappable_cdev_bdi },

This patch has several checkpatch errors wrt. the spacing used in the
array index..

Kay, can you send a follow up patch to correct them?

Daniel

