Return-Path: <linux-kernel-owner+w=401wt.eu-S1756257AbZAGH6n@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257AbZAGH6n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jan 2009 02:58:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752120AbZAGH6Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Jan 2009 02:58:24 -0500
Received: from courier.cs.helsinki.fi ([128.214.9.1]:59021 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751449AbZAGH6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jan 2009 02:58:24 -0500
Subject: Re: 2.6.29 -mm merge plans
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ryusuke Konishi <konishi.ryusuke@lab.ntt.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       Chris Mason <chris.mason@oracle.com>
In-Reply-To: <20090107.122653.111144635.ryusuke@osrg.net>
References: <20090105004300.19ed52d1.akpm@linux-foundation.org>
	 <c4a7c9420901050140u23697729pc55966110d68452b@mail.gmail.com>
	 <84144f020901060530w2b7fef67j8f1f2242860df3bd@mail.gmail.com>
	 <20090107.122653.111144635.ryusuke@osrg.net>
Date: Wed, 07 Jan 2009 09:58:21 +0200
Message-Id: <1231315101.14720.0.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2009-01-07 at 12:26 +0900, Ryusuke Konishi wrote:
> The use of panic() call is a mimic of ext2/3, and this is called only
> if an "errors=panic" mount option is specified.
> Do you think it should be removed along with the mount option for
> new filesystems ?

No, no, that's fine. I didn't look where the panic was just spotted it
along the BUG_ON calls.

