Return-Path: <linux-kernel-owner+w=401wt.eu-S1753843AbXISDGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843AbXISDGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2007 23:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751737AbXISDGF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 18 Sep 2007 23:06:05 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40248 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751009AbXISDGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2007 23:06:03 -0400
Date: Tue, 18 Sep 2007 20:05:15 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Avantika Mathur <mathur@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org,
       Andreas Dilger <adilger@clusterfs.com>, cmm@us.ibm.com
Subject: Re: [PATCH] Ext4: Uninitialized Block Groups
Message-Id: <20070918200515.0b320062.akpm@linux-foundation.org>
In-Reply-To: <46F06C7B.20308@linux.vnet.ibm.com>
References: <46F06C7B.20308@linux.vnet.ibm.com>
X-Mailer: Sylpheed 2.4.1 (GTK+ 2.8.17; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Sep 2007 17:25:31 -0700 Avantika Mathur <mathur@linux.vnet.ibm.com> wrote:

> +
> +__u16 crc16(__u16 crc, __u8 const *buffer, size_t len)

And is we really really have to do this, then the ext4-private crc16() 
should have static scope.
