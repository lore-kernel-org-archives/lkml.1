Return-Path: <linux-kernel-owner+w=401wt.eu-S1756222AbXINKcd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756222AbXINKcd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2007 06:32:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753691AbXINKcY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 14 Sep 2007 06:32:24 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33235 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753403AbXINKcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2007 06:32:23 -0400
Date: Fri, 14 Sep 2007 03:32:16 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: linux-box <bo.yang@lsi.com>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@SteelEye.com,
       linux-kernel@vger.kernel.org, sumant.patro@lsi.com
Subject: Re: [PATCH 3/4] scsi: megaraid_sas - add module param max_sectors,
 cmd_per_lun
Message-Id: <20070914033216.858d12e0.akpm@linux-foundation.org>
In-Reply-To: <1189514073.6082.14.camel@dhcp-75-534.se.lsil.com>
References: <1189514073.6082.14.camel@dhcp-75-534.se.lsil.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Sep 2007 08:34:33 -0400 linux-box <bo.yang@lsi.com> wrote:

> +	struct megasas_instance *instance =
> +				(struct megasas_instance *)host->hostdata;

y'know, if some brave soul were to write

static inline void *scsi_host_data(struct Scsi_Host *host)
{
	return (void *)host->hostdata;
}

we could remove about 100000000000 ugly casts from scsi.

Just a thought...

