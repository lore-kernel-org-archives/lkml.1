Return-Path: <linux-kernel-owner+w=401wt.eu-S1755421Ab0AFEl7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab0AFEl7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jan 2010 23:41:59 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755191Ab0AFEl5
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 5 Jan 2010 23:41:57 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60439
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754759Ab0AFEl5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jan 2010 23:41:57 -0500
Date: Tue, 05 Jan 2010 20:42:01 -0800 (PST)
Message-Id: <20100105.204201.34378986.davem@davemloft.net>
To: heiko.carstens@de.ibm.com
Cc: arjan@infradead.org, arnd@arndb.de, mingo@elte.hu,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: copy_from_user() should not return -EFAULT
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100105152215.GD5480@osiris.boeblingen.de.ibm.com>
References: <20100105131911.GC5480@osiris.boeblingen.de.ibm.com>
	<20100105053117.6a7c3377@infradead.org>
	<20100105152215.GD5480@osiris.boeblingen.de.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Heiko Carstens <heiko.carstens@de.ibm.com>
Date: Tue, 5 Jan 2010 16:22:15 +0100

> Subject: [PATCH] sparc: copy_from_user() should not return -EFAULT
> 
> From: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Callers of copy_from_user() expect it to return the number of bytes
> it could not copy. In no case it is supposed to return -EFAULT.
> 
> In case of a detected buffer overflow just return the requested
> length. In addition one could think of a memset that would clear
> the size of the target object.
> 
> Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>

Applied, thanks again for catching this.
