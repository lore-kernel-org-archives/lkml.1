Return-Path: <linux-kernel-owner+w=401wt.eu-S1757829AbZBLIuf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829AbZBLIuf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Feb 2009 03:50:35 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754961AbZBLIu0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Feb 2009 03:50:26 -0500
Received: from mail-ew0-f21.google.com ([209.85.219.21]:42720 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbZBLIu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Feb 2009 03:50:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=km3wj6Aro6F7CFraLOXhr6u30XyECmpZnDwccEB0cgcrqxyVOIRiy5y6F1Z6UuObdS
         cID5nPNgmrSI32RhFSS+9NvM/FOMN1qm+kf6wzsJ9BoKWLgQIbaigVaIUChL2Fna6y0d
         s0BvrKVS+Xq5+QsG/nJJRHcYU3XjlCA3FVZX4=
Message-ID: <4993E2CA.1070408@panasas.com>
Date: Thu, 12 Feb 2009 10:50:18 +0200
From: Boaz Harrosh <bharrosh@panasas.com>
User-Agent: Thunderbird/3.0a2 (X11; 2008072418)
MIME-Version: 1.0
To: Harvey Harrison <harvey.harrison@gmail.com>
CC: Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org
Subject: Re: get/put unaligned helpers
References: <20090211143521.GA18866@lst.de> <1234367339.5481.3.camel@brick>
In-Reply-To: <1234367339.5481.3.camel@brick>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Harvey Harrison wrote:
> On Wed, 2009-02-11 at 15:35 +0100, Christoph Hellwig wrote:
>> I just loked into using the new get/put unaligned helpers.  I must
>> say that I'm really unhappy about the lack of typing there.  We did
>> put all the sparse infrastructure in place to make sure we do have
>> strong typechecking for LE/Be types, but using these helpers defeats
>> that.
>>
>> Can you please make these properly typed?
> 
> Sorry, real life got in the way, I had a series in -mm for a few months
> that did the typing and fixed the argument ordering by providing a
> load/store API and then moving the existing users across, but that got
> delayed while the (aligned) byteswapping patches were made suitable
> for mainline.
> 
> I'll get that series revived shortly.
> 
> Harvey
> 

Speaking of which. When all this is done do you intend to also export
the unaligned.h headers to user-mode just like the aligned Endian helpers?

That could help in a couple of projects, so you have my vote.

Thanks
Boaz
