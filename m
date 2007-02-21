Return-Path: <linux-kernel-owner+w=401wt.eu-S1161142AbXBUI5T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161142AbXBUI5T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Feb 2007 03:57:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1161145AbXBUI5T
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Feb 2007 03:57:19 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:42377 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161142AbXBUI5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Feb 2007 03:57:18 -0500
Subject: Re: [PATCH 2/3] slab: export ksize to modules
From: Arjan van de Ven <arjan@infradead.org>
To: Pekka J Enberg <penberg@cs.helsinki.fi>
Cc: akpm@linux-foundation.org, clameter@sgi.com, linux-kernel@vger.kernel.org,
       jsipek@fsl.cs.sunysb.edu, unionfs@filesystems.org, bunk@stusta.de,
       hooanon05@yahoo.co.jp
In-Reply-To: <Pine.LNX.4.64.0702211006210.8172@sbz-30.cs.Helsinki.FI>
References: <Pine.LNX.4.64.0702211006210.8172@sbz-30.cs.Helsinki.FI>
Content-Type: text/plain
Organization: Intel International BV
Date: Wed, 21 Feb 2007 09:56:50 +0100
Message-Id: <1172048210.3531.167.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.2.1 (2.8.2.1-3.fc6) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-02-21 at 10:06 +0200, Pekka J Enberg wrote:
> From: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> This exports ksize in slab and slob allocators to modules.


what's the user of this? If none, don't export it please since every
useless export does take up space.
Please specify the use in the description of the patch!

