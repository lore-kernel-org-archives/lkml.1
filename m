Return-Path: <linux-kernel-owner+w=401wt.eu-S1757004AbYHOKhq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757004AbYHOKhq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2008 06:37:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755351AbYHOKha
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Aug 2008 06:37:30 -0400
Received: from py-out-1112.google.com ([64.233.166.180]:43430 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754106AbYHOKh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2008 06:37:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=qeb94TwnMDJrroO1vBdEH9kE+aDRoMZh5ZgOWEl8Ql/BctoB0S348Mel8dNGpmEfVn
         o3sdR6KyP9yHPVIU4JWO+wW6etTDNLvnvebZ9STu6CrOBfIP5/hMqYN7CPHFuIvj4OVE
         6bTqjIvfhPAbc26aH3drmTh4kHmeFDp1EGNC4=
Message-ID: <e7d8f83e0808150337t5e699647wcc6ae296b3fa8c23@mail.gmail.com>
Date: Fri, 15 Aug 2008 20:37:27 +1000
From: "Peter Dolding" <oiaohm@gmail.com>
To: "Pavel Machek" <pavel@suse.cz>
Subject: Re: [PATCH 1/4] integrity: TPM internel kernel interface
Cc: "Kenneth Goldman" <kgoldman@us.ibm.com>,
       "Christoph Hellwig" <hch@infradead.org>, linux-kernel@vger.kernel.org,
       linux-security-module@vger.kernel.org, "Mimi Zohar" <zohar@us.ibm.com>
In-Reply-To: <20080814111210.GI6995@ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080812193031.GD18034@infradead.org>
	 <OF6C940C00.249617D7-ON852574A3.0071F8B0-852574A3.00732160@us.ibm.com>
	 <20080814111210.GI6995@ucw.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 14, 2008 at 9:12 PM, Pavel Machek <pavel@suse.cz> wrote:
> Hi!
>
>> > And what happens when the chip simply goes away due to a hotplug action?
>> > Or not even the actual chip goes away but just the chip driver and you
>> > now dereference freed memory?
>>
>> Being a TCG/TPM person, I can only address the first question.  The
>> intent is that the TPM is soldered to the planar/motherboard (the TCG
>> uses the phrase "bound to the platform").  I can't imagine
>> any manufacturer designing a pluggable TPM.  It would subvert PCR
>
> Only 2 TPMs I've seen were on pluggable modules... which was fortunate
> because they slowed down boot by 5+ minutes, and broke it completely
> in other cases. Nickname 'kurvitko' (aka useless trash that breaks
> stuff). They are currently lying under my table, disconnected.
>
> (OTOH they were not on PCI, but on some low-count pin header).
>                                                        Pavel
Remember even soldered on stuff can fail.   How linux handles the
death of the TPM module needs to be covered.

Peter Dolding
