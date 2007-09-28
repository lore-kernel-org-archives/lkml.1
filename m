Return-Path: <linux-kernel-owner+w=401wt.eu-S1754849AbXI1R6K@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754849AbXI1R6K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 13:58:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753290AbXI1R55
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 13:57:57 -0400
Received: from wr-out-0506.google.com ([64.233.184.230]:48550 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753085AbXI1R55 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 13:57:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=LtDEMCapLNtIOgzqeC22qWAA9TLEdJg6skwoyGA8dHAZVMK8JlOEizTFJmkbHw1d+r0o5ZFLuSwNORt64SVMkA+Yao/KzPGlgN8fmHQKqEuWCutNgVIhXBqnBuU2c6+w/1hWvFxG3KFc5h7oL3tKZagqIrH8SyD9DVKUzXNnDTI=
Message-ID: <dd4eba420709281057x69a9366cp8fc755782efea656@mail.gmail.com>
Date: Fri, 28 Sep 2007 21:57:55 +0400
From: "Sergey Popov" <faijeya@gmail.com>
To: linux-kernel@vger.kernel.org
Subject: Re: General slowness with using 64Gb HIGHMEM option on 32-bit kernel
In-Reply-To: <46FD3DE1.9000807@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd4eba420709281015w50bd6b0fj21f72756a962a26b@mail.gmail.com>
	 <46FD3DE1.9000807@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, I found a palliative.

Now I'm working with "mem=6770M" option, that gives me 6072MB RAM (of
6144 total).
Interesting, that if you choose too much, like "mem=6800M", system
behaviour is exactly the same as without any options.

Can it be that kernel incorrectly sets amount of memory to use so such
a situation occurs?
