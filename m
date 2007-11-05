Return-Path: <linux-kernel-owner+w=401wt.eu-S1754331AbXKETn6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331AbXKETn6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2007 14:43:58 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751938AbXKETnt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 5 Nov 2007 14:43:49 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:36998 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbXKETns (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2007 14:43:48 -0500
Date: Mon, 5 Nov 2007 11:43:35 -0800
From: "Darrick J. Wong" <djwong@us.ibm.com>
To: Adrian Bunk <bunk@kernel.org>
Cc: James.Bottomley@SteelEye.com, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [2.6 patch] scsi/aic94xx/: cleanups
Message-ID: <20071105194334.GA7010@tree.beaverton.ibm.com>
References: <20071105170729.GO12045@stusta.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20071105170729.GO12045@stusta.de>
User-Agent: Mutt/1.5.15+20070412 (2007-04-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 05, 2007 at 06:07:29PM +0100, Adrian Bunk wrote:
> This patch contains the following cleanups:
> - static functions in .c files shouldn't be marked inline
> - make needlessly global code static
> - #if 0 unused code

asd_unpause_lseq can be removed; the other if 0'd functions are debug
functions and can probably stay.

Otherwise, ack.

--D
