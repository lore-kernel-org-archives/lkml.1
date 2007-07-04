Return-Path: <linux-kernel-owner+w=401wt.eu-S1757712AbXGDGIS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbXGDGIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2007 02:08:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751529AbXGDGIK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 4 Jul 2007 02:08:10 -0400
Received: from wa-out-1112.google.com ([209.85.146.182]:31430 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103AbXGDGIJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2007 02:08:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=fWMtubUCU5O0K4+Y9eVm8MbkdyE0WPJzbdl05OgmAHabCjk3bUN5CKfy3PqEZhkHWOh6BWYWlQIBLoQLPmPV2etleMUDypYKS3oXnspg8pd0OiLv1oWkGyk1vkJewrnJRMYscGrk2uV2n8fbrCOaLQk/+Bzv4tBy8bTMoIzd2Qo=
Message-ID: <86802c440707032308w3f596ff1gd17faaded43ff894@mail.gmail.com>
Date: Tue, 3 Jul 2007 23:08:08 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Greg KH" <greg@kroah.com>
Subject: Re: [PATCH 3/4] usb: allocated usb releated dma buffer with kmalloc_node
Cc: linux-usb-devel@lists.sourceforge.net, "Andi Kleen" <ak@suse.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20070703060155.GB19086@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200706291326.43563.yinghai.lu@sun.com>
	 <200707021536.37814.yinghai.lu@sun.com>
	 <20070703051129.GA18420@kroah.com>
	 <86802c440707022233g2021b49dg48534f813f628585@mail.gmail.com>
	 <20070703060155.GB19086@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 7/2/07, Greg KH <greg@kroah.com> wrote:
> On Mon, Jul 02, 2007 at 10:33:12PM -0700, Yinghai Lu wrote:
> Ok, so two drivers might need this, but not the whole usb core, right?
>
> And even if you do have another usb mapping, is that a real problem?
> USB keyboards and mice are very slow.

Some other USB media may need that too.

if you have one two way system and put all dimm on node1 and use
memtest to look at performance. you may agree to reduce the cross node
mem access as less as possible.

YH
