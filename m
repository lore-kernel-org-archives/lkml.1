Return-Path: <linux-kernel-owner+w=401wt.eu-S1753824AbYKCR4T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753824AbYKCR4T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2008 12:56:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751820AbYKCR4F
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 3 Nov 2008 12:56:05 -0500
Received: from an-out-0708.google.com ([209.85.132.247]:37232 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbYKCR4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2008 12:56:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:reply-to:to:subject:cc:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:references;
        b=oWPbmZysHnMF6UCfffjS30qv9AlQWnrfBPMA32eYij8wD9NpDpyn1a37ZkqlONFRfs
         3vysFtyhIH6Wj3rBZZQljSpGOpaQnImaDlLaHbKG+YHP6PnfMczAOhd1vRsKlDWy6qhE
         h3+rcaO0e8rBfeqVBxDUtyGJnYwDMkB4x70Eg=
Message-ID: <9ea470500811030956k209b2f2ci10bcde1ea4ac7334@mail.gmail.com>
Date: Mon, 3 Nov 2008 18:56:01 +0100
From: "Borislav Petkov" <petkovbb@googlemail.com>
Reply-To: petkovbb@gmail.com
To: "Tejun Heo" <tj@kernel.org>
Subject: Re: [RFC PATCH] ide-floppy partitions
Cc: axboe@kernel.dk, bzolnier@gmail.com, linux-ide@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <490F1AC6.8000109@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20081029071319.GA9205@gollum.tnic>
	 <20081101201419.GA29462@gollum.tnic> <490F1AC6.8000109@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Mon, Nov 3, 2008 at 4:37 PM, Tejun Heo <tj@kernel.org> wrote:
> Borislav Petkov wrote:
>> can you guys please ACK/NACK this so that we can have an agreed upon solution
>> and so that I can stop applying it ontop of current git before testing any
>> further.
>
> Ah... right.  I missed removable devices.  I think it would be better to
> just expand the table rather than recursing into __blkdev_get() again.
> I'll try to come up with cleaner solution.

Sounds good. It should simply rescan partitions upon media change before it does
disk_get_part so that the ptbl is updated.

> Also, I don't think the
> discontinuous partition would be a problem.  ptbl is expanded to the
> highest numbered partition not the number of partitions.  I'll test that
> too.  Thanks.

You don't have to. I already did that with a harddrive in a external case over
usb and it works since upon connection the usb core rescans partitions and ptbl
is valid then.

Thanks.

-- 
Regards/Gruss,
Boris
