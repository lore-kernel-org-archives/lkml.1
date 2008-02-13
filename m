Return-Path: <linux-kernel-owner+w=401wt.eu-S1756955AbYBMWEN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756955AbYBMWEN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Feb 2008 17:04:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934427AbYBMVvn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 Feb 2008 16:51:43 -0500
Received: from e6.ny.us.ibm.com ([32.97.182.146]:52376 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934988AbYBMVvl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Feb 2008 16:51:41 -0500
Subject: Re: [PATCH] jfs: le*_add_cpu conversion
From: Dave Kleikamp <shaggy@linux.vnet.ibm.com>
To: marcin.slusarz@gmail.com
Cc: LKML <linux-kernel@vger.kernel.org>, jfs-discussion@lists.sourceforge.net
In-Reply-To: <1202857582-15450-12-git-send-email-marcin.slusarz@gmail.com>
References: <1202857582-15450-1-git-send-email-marcin.slusarz@gmail.com>
	 <1202857582-15450-12-git-send-email-marcin.slusarz@gmail.com>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 15:51:34 -0600
Message-Id: <1202939494.6857.21.camel@norville.austin.ibm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.12.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2008-02-13 at 00:06 +0100, marcin.slusarz@gmail.com wrote:
> From: Marcin Slusarz <marcin.slusarz@gmail.com>
> 
> replace all:
> little_endian_variable = cpu_to_leX(leX_to_cpu(little_endian_variable) +
> 					expression_in_cpu_byteorder);
> with:
> 	leX_add_cpu(&little_endian_variable, expression_in_cpu_byteorder);
> generated with semantic patch
> 
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: shaggy@austin.ibm.com
> Cc: jfs-discussion@lists.sourceforge.net

Applied to the jfs git tree.

Thanks,
Shaggy
-- 
David Kleikamp
IBM Linux Technology Center

