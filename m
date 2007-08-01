Return-Path: <linux-kernel-owner+w=401wt.eu-S932403AbXHAO1t@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932403AbXHAO1t (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2007 10:27:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753240AbXHAO1k
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Aug 2007 10:27:40 -0400
Received: from nf-out-0910.google.com ([64.233.182.189]:56899 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754187AbXHAO1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2007 10:27:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=beta;
        h=received:message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=utaqg7Nd1III5nl/ShABynO3w3O25NcNUheBuBzCEQS9tjoO7dUkXkyuAd5JyFsjcYstYAYidje0FjxRelZIl7/5hGixf9CJ2Z0hXZ5QQ5IR0u9smLfP2z3jCxcsrFnybDcKhc8e9kHSrqrQQuz9XylXhCfFJu/HgRX+/b7CEsg=
Message-ID: <46B09843.7010701@googlemail.com>
Date: Wed, 01 Aug 2007 16:27:15 +0200
From: Gabriel C <nix.or.die@googlemail.com>
User-Agent: Thunderbird 2.0.0.5 (X11/20070721)
MIME-Version: 1.0
To: Matthew Wilcox <matthew@wil.cx>
CC: Eugene Teo <eugeneteo@kernel.sg>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-scsi@vger.kernel.org
Subject: Re: [PATCH] drivers/scsi/advansys.c: fix advansys_board_found compile
 error
References: <20070731230932.a9459617.akpm@linux-foundation.org> <46B0842D.3060703@googlemail.com> <20070801133912.GA11027@kernel.sg> <20070801135515.GV21219@parisc-linux.org>
In-Reply-To: <20070801135515.GV21219@parisc-linux.org>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Wilcox wrote:
> On Wed, Aug 01, 2007 at 09:39:12PM +0800, Eugene Teo wrote:
>> This patch fixes the following compile error:
>>
>> drivers/scsi/advansys.c: In function 'advansys_board_found':
>> drivers/scsi/advansys.c:17781: error: implicit declaration of function
>> 'to_pci_dev'
> 
> Or just remove the ifdefs around the include ... which is done in this
> patch:
> 
> http://www.kernel.org/pub/linux/kernel/people/willy/advansys-2007-07-30/0001-advansys-version-copyright-etc.txt
> 
> I'd be interested in seeing the results of the randconfig trials on the
> driver with those 23 patches applied, but not particularly interested in
> the intermediate result.
> 

I can do that on weekend.

Are the patches meant for -mm or git head ?
