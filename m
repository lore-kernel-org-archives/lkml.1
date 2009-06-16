Return-Path: <linux-kernel-owner+w=401wt.eu-S1764311AbZFPUqf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764311AbZFPUqf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jun 2009 16:46:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1764716AbZFPUpi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Jun 2009 16:45:38 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:37372 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764126AbZFPUph convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jun 2009 16:45:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ij4spJV5VPrQQTiHgCFgKJlmFmNyCSUus2JhF+7rJTmxV6D3MqmOu2HKLVECPevLDV
         Jh3jiZcFdfSOq9heNAiyNvHcT2Xfi+tmRmTcmGY7yssk/962DgaiTB2URgMJ1fqcs9Pm
         M3sXINgPd/RUIjvr1tQKJaVTqNFoTK47Rj03A=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.01.0906161119500.3282@localhost.localdomain>
References: <alpine.DEB.2.00.0906150302250.20307@skynet.skynet.ie>
	 <20090615022235.GA12905@kroah.com>
	 <21d7e9970906141943s8dd6e27sd4308413601d65e3@mail.gmail.com>
	 <48f7fe350906160853m41f43fe5i892a4057b5eae319@mail.gmail.com>
	 <alpine.LFD.2.01.0906161119500.3282@localhost.localdomain>
Date: Wed, 17 Jun 2009 06:45:39 +1000
Message-ID: <21d7e9970906161345q6e826d18q3a197643e370156c@mail.gmail.com>
Subject: Re: [git pull] drm - fixes + radeon KMS (part 2)
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ryan Hope <rmh3093@gmail.com>, Greg KH <greg@kroah.com>,
       Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
       dri-devel@lists.sf.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 17, 2009 at 4:20 AM, Linus
Torvalds<torvalds@linux-foundation.org> wrote:
>
>
> On Tue, 16 Jun 2009, Ryan Hope wrote:
>>
>> +#ifdef MODULE
>>  module_init(radeon_init);
>> +#else
>> +late_initcall(radeon_init);
>> +#endif
>
>
> You should never need something like that.
>
> Just do
>
>        late_initcall(radeon_init);

I actually don't think we need either of them, the ordering shuoldn't
matter, its just a bug we need to fix
in the radeon code during staging I expect, in theory you should be
able to load fbcon before/after radeon.

I don't think the intel code suffers from this issue.

Linus can you pull this tree?

Dave.
