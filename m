Return-Path: <linux-kernel-owner+w=401wt.eu-S1756124AbYIJWXr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756124AbYIJWXr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Sep 2008 18:23:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751633AbYIJWXi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 10 Sep 2008 18:23:38 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:49400 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751508AbYIJWXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Sep 2008 18:23:37 -0400
Date: Wed, 10 Sep 2008 15:22:58 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: marcin_obara@users.sourceforge.net, tpm@selhorst.net, kjhall@us.ibm.com,
       linux-kernel@vger.kernel.org, srajiv@linux.vnet.ibm.com,
       debora@linux.vnet.ibm.com
Subject: Re: tpm-correct-tpm-timeouts-to-jiffies-conversion.patch -> 2.6.27
Message-Id: <20080910152258.762e3714.akpm@linux-foundation.org>
In-Reply-To: <48C84619.8030303@gmail.com>
References: <48C84619.8030303@gmail.com>
X-Mailer: Sylpheed version 2.2.4 (GTK+ 2.8.20; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Sep 2008 00:11:37 +0200
Jiri Slaby <jirislaby@gmail.com> wrote:

> Hi,
> 
> is it possible to push
> tpm-correct-tpm-timeouts-to-jiffies-conversion.patch
> (the patch header follows) into 2.6.27, please?

Sure.

> From: Marcin Obara <marcin_obara@users.sourceforge.net>
> 
> This patch fixes timeouts conversion to jiffies, by replacing
> msecs_to_jiffies() calls with usecs_to_jiffies().  According to TCG TPM
> Specification Version 1.2 Revision 103 (pages 166, 167) TPM timeouts and
> durations are returned in microseconds (usec) not in miliseconds (msec).
> 
> Signed-off-by: Marcin Obara <marcin_obara@users.sourceforge.net>
> Cc: Marcel Selhorst <tpm@selhorst.net>
> Cc: Kylene Jo Hall <kjhall@us.ibm.com>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>

Why?  I wasn't aware that this fixed anything which anyone had observed
(pokes tongue out at the changelog).

