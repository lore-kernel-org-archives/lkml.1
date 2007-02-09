Return-Path: <linux-kernel-owner+w=401wt.eu-S1752575AbXBIXyc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752575AbXBIXyc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 18:54:32 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752580AbXBIXyc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 18:54:32 -0500
Received: from ug-out-1314.google.com ([66.249.92.168]:43962 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575AbXBIXyb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 18:54:31 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=QcbZ8aP0N0oyJ27L0yTYN18a9Y+Xib/s5TgcOzBGdv+g211Qo9PmZkqJmphlDgg0Ox3lCUvxs/wj87GNGrL6d8Jj21PHEkySDvLqW6feBxFtFfnHQLaCaDuDuEkWnVQpfa1xGXs0UtlWMmNZXteQmucRZrPGc85Re91WOoYzhSo=
Message-ID: <7579f7fb0702091554v3dbd5ae9ldcddcc4cca549548@mail.gmail.com>
Date: Fri, 9 Feb 2007 15:54:29 -0800
From: "Matthew Jacob" <lydianconcepts@gmail.com>
To: "Kumar Gala" <galak@kernel.crashing.org>
Subject: Re: DMA mapping API for non-system memory pools
Cc: "Russell King" <rmk@arm.linux.org.uk>,
       "James Bottomley" <James.Bottomley@hansenpartnership.com>,
       "Linux Kernel list" <linux-kernel@vger.kernel.org>
In-Reply-To: <4479FB80-8703-4BCA-925E-DA25B65EE916@kernel.crashing.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <4479FB80-8703-4BCA-925E-DA25B65EE916@kernel.crashing.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Yes- this would be interesting to know wrt to doing things like
PCI<>PCI xfers (e.g., for things like the Micromemory NVRAM card).

On 2/9/07, Kumar Gala <galak@kernel.crashing.org> wrote:
> We've been having a discussion on the linuxppc-dev list about how to
> handle IO memory that exists on some PPC SoC devices.  These IO
> memories behave like system memory but are faster to the processor or
> device needed accessing for things like buffer descriptors.
>
