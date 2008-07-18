Return-Path: <linux-kernel-owner+w=401wt.eu-S1756847AbYGRJ2f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756847AbYGRJ2f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2008 05:28:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754000AbYGRJ21
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jul 2008 05:28:27 -0400
Received: from fk-out-0910.google.com ([209.85.128.186]:55812 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369AbYGRJ20 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2008 05:28:26 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=JjLuX6vVFlazDUzWfvsCoey8aFJ51f25Q6b/b+iLS+W1iTh5GNXcU4vfrOtSDKL6E4
         JGdautZcz0HD/M3YvxPmKG0yUobl+zsTfFwU2BSEy76EGMDwtRq8j/Ewq/Kay/8eZkJx
         1PW+1iiSiYx9B8o1KrkAmAWGcE3UtPzr6KsI8=
Date: Fri, 18 Jul 2008 13:28:11 +0400
From: Dmitry Baryshkov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/3] Generic dma-coherent updates
Message-ID: <20080718092810.GA2423@doriath.ww600.siemens.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here are some patches for the tip core/generic-dma-coherent branch.

The first one fixes dma allocation from DMA_MEMORY_EXCLUSIVE memory
areas. Second adds per-device coherent mem to arm and third one
replaces SH per-device coherent memory allocations with generic version.

I've tried updating Cris, but failed to even compile the kernel.


-- 
With best wishes
Dmitry

