Return-Path: <linux-kernel-owner+w=401wt.eu-S1760158AbXFRA5s@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760158AbXFRA5s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2007 20:57:48 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752851AbXFRA5j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Jun 2007 20:57:39 -0400
Received: from an-out-0708.google.com ([209.85.132.251]:11689 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750980AbXFRA5i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2007 20:57:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=Xx2V1wCwnfX5LT21ilLOR2CMVHyc/tkO63h5HFfaPJk8wqZGYgWgJGYPSKTPFgW7iiFmYeLfSs/QB2nROSbndDDz0GMBShh6D7fXZb8JsCq+J+OGOMPN+imu1kzlr2j7nAnwOYBAjsVMd71lxrc6QrdIj855E3cfX4/WeDAIb+Q=
Message-ID: <21d7e9970706171757n4709383cv7a39a66103edc370@mail.gmail.com>
Date: Mon, 18 Jun 2007 10:57:38 +1000
From: "Dave Airlie" <airlied@gmail.com>
To: "Dave Jones" <davej@redhat.com>, "Carlo Wood" <carlo@alinoe.com>,
       linux-kernel@vger.kernel.org, eric@anholt.net, zhenyu.z.wang@intel.com
Subject: Re: [AGPGART] intel_agp: use table for device probe
In-Reply-To: <20070618001627.GA18598@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070614011506.GA30566@alinoe.com>
	 <20070617190714.GA18115@redhat.com> <20070617195901.GA5689@alinoe.com>
	 <20070617204904.GB3430@redhat.com> <20070617211338.GA24771@alinoe.com>
	 <20070617213355.GC3430@redhat.com> <20070617223649.GA31587@alinoe.com>
	 <20070617224918.GC12483@redhat.com> <20070618000643.GA1375@alinoe.com>
	 <20070618001627.GA18598@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

>
> Right now, I'm at a loss to explain the corruption, so it's
> difficult to suggest what to try.

The thing is here, this is PCIE, so if there is a GPU plugged into the
PCIE 16x slot in theory the main onboard graphics should disable, AGP
code is used to control the GART for the onboard chip, in this case a
plugged in card will  not use AGP, I wonder have Intel tested with a
pcie card in place...

Dave.
