Return-Path: <linux-kernel-owner+w=401wt.eu-S1755393AbYJUW3k@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755393AbYJUW3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2008 18:29:40 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756386AbYJUW30
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Oct 2008 18:29:26 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:18190 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756342AbYJUW3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2008 18:29:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qzixT3MRT95curqAx6GsYa2esgp1wm4xNBH+7Zl+2bsvkzYTFjo8si/UgxpbKxqVNw
         L5CGQjJXwocfkVci9ONhmxBMQE4oHoVf0LSG6tFUNT88UY9eLagWJPGPZf8I0UMi8Qg5
         pPMvzcibZEXUxf/R1NI5o/GAFuwA0GU4Mnlkw=
Message-ID: <81b0412b0810211529x3fc85567yc34fd369ff7c8518@mail.gmail.com>
Date: Wed, 22 Oct 2008 00:29:22 +0200
From: "Alex Riesen" <raa.lkml@gmail.com>
To: "Phillip Lougher" <phillip@lougher.demon.co.uk>
Subject: Re: Subject: [PATCH 00/16] Squashfs: compressed read-only filesystem
Cc: akpm@linux-foundation.org, linux-embedded@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       tim.bird@am.sony.com
In-Reply-To: <E1KqrTW-0001x8-3h@dylan>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <E1KqrTW-0001x8-3h@dylan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/17 Phillip Lougher <phillip@lougher.demon.co.uk>:
> There are 16 patches in the patch set, and the patches are against the
> latest linux-next tree (linux 2.6.27-next-20081016).

You better don't base anything off linux-next. These are not stable: there
can be even something in the tree you mentioned which will never end
up in the mainline and if your patches depend on it they wont apply to
something like v2.6.26.2.

Use something tagged (v2.6.27, v2.6.27-rc*) in _mainline_ instead.
Than it can be applied to anything from stable releases to vendor trees
(which mostly are based off mainline).
