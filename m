Return-Path: <linux-kernel-owner+w=401wt.eu-S1760711AbZE0Uyy@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760711AbZE0Uyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 May 2009 16:54:54 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757776AbZE0Uyb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 27 May 2009 16:54:31 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:61222 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbZE0Uya convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 May 2009 16:54:30 -0400
MIME-Version: 1.0
In-Reply-To: <20090527201951.GF30039@game.jcrosoft.org>
References: <ed82fe3e0905270739k38018c87ka11f62c5977e45fb@mail.gmail.com> 
	<87vdnm8sec.fsf@macbook.be.48ers.dk> <4A1D6901.2090508@freescale.com> 
	<20090527175609.GB31861@flint.arm.linux.org.uk> <4A1D8FBA.6040802@freescale.com> 
	<9e4733910905271213k7f4b93e7i7e6f2af24d85f@mail.gmail.com> 
	<20090527192116.GA31110@n2100.arm.linux.org.uk> <20090527193927.GD30039@game.jcrosoft.org> 
	<fa686aa40905271322x2f62c3dcs355374b30b4db3ca@mail.gmail.com> 
	<20090527201951.GF30039@game.jcrosoft.org>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Wed, 27 May 2009 14:54:10 -0600
Message-ID: <fa686aa40905271354y50b9583cp9f53c35354edc285@mail.gmail.com>
Subject: Re: [RFC] [PATCH] Device Tree on ARM platform
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       devicetree-discuss <devicetree-discuss@ozlabs.org>,
       linux-kernel@vger.kernel.org, Timur Tabi <timur@freescale.com>,
       Jon Smirl <jonsmirl@gmail.com>, Scott Wood <scottwood@freescale.com>,
       Janboe Ye <yuan-bo.ye@motorola.com>,
       linux-arm-kernel@lists.arm.linux.org.uk
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 27, 2009 at 2:19 PM, Jean-Christophe PLAGNIOL-VILLARD
<plagnioj@jcrosoft.com> wrote:
>> One option that has been suggested (more than once) is to make the
>> adapter code an of_platform_driver which translates the device tree
>> data and then registers the appropriate platform_devices.  This neatly
>> solves the problem, but I don't like the overhead involved in
>> registering 2 struct devices with the kernel for every device node in
>> the device tree.
> but simplify the dev and maintaining is also an important goal.
>
> Have to duplicated ressource handling via ifdef in every drivers is also an
> overhead which need to be avoided

agreed.  I don't have a best of both worlds answer here.

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
