Return-Path: <linux-kernel-owner+w=401wt.eu-S1760016AbYHUOhk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760016AbYHUOhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2008 10:37:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754883AbYHUOha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Aug 2008 10:37:30 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:27599 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751732AbYHUOh3 (ORCPT
	<rfc822;Linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2008 10:37:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=TijGbCcZDJ6H7dnQCHu6HQYwVcSXWTGHKLWs9f72YEtx2IOPq4vnRR3wQc+tu6aEW4
         GsHSx84GXiTZVu0BY8jebuW1kevSelCmR4IlCH/okFwWAwysB+NDHvcUX9EgtCwLdMBn
         msLI3tLncRxV1/GM5x6ASzSO+shsX5Zf7CWWU=
Message-ID: <6934efce0808210737w16b5f8dcr1657ea46099e4901@mail.gmail.com>
Date: Thu, 21 Aug 2008 07:37:27 -0700
From: "Jared Hulbert" <jaredeh@gmail.com>
To: "Sven Wegener" <sven.wegener@stealer.net>
Subject: Re: [PATCH 10/10] AXFS: axfs_uncompress.c
Cc: Linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
       linux-mtd <linux-mtd@lists.infradead.org>,
       "=?UTF-8?Q?J=C3=B6rn_Engel?=" <joern@logfs.org>, tim.bird@am.sony.com,
       cotte@de.ibm.com, nickpiggin@yahoo.com.au
In-Reply-To: <alpine.LNX.1.10.0808211028150.12259@titan.stealer.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48AD0126.1050609@gmail.com>
	 <alpine.LNX.1.10.0808211028150.12259@titan.stealer.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Use DEFINE_MUTEX and drop the mutex_init() down in the init function.

okay.  by drop you mean delete?

> axfs_uncompress_init() and axfs_uncompress_exit() are only called during
> init and exit of the module, no need for the initialized variable and the
> functions can be annotated with __init and __exit.

can be annotated or should be?
