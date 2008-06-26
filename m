Return-Path: <linux-kernel-owner+w=401wt.eu-S1755716AbYFZWd3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755716AbYFZWd3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jun 2008 18:33:29 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752537AbYFZWdT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 26 Jun 2008 18:33:19 -0400
Received: from yw-out-2324.google.com ([74.125.46.30]:24842 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752491AbYFZWdS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jun 2008 18:33:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=CJqiZ30Y664GN00wcF7FcifPVYH1WyxBORcdTLTHgFg35zuYhhxA/un5mfAYUZ8KV8
         um6U55Pz/eOWO516350v/fVC8JqY9LmDLZtaC8kwqJCdUAHwTpimLptic+YByYrAIJ4B
         bZWlahA/jxfYhY8/fDZjAiWmyezgAQcvUbsvo=
Message-ID: <e9c3a7c20806261533v1e63f889s6c1fafb010429e0c@mail.gmail.com>
Date: Thu, 26 Jun 2008 15:33:16 -0700
From: "Dan Williams" <dan.j.williams@intel.com>
To: "Nicolas Pitre" <nico@cam.org>
Subject: Re: [PATCH/RFC] DMA engine driver for Marvell XOR engine
Cc: "Maciej Sosnowski" <maciej.sosnowski@intel.com>,
       "Saeed Bishara" <saeed@marvell.com>,
       "Lennert Buytenhek" <buytenh@wantstofly.org>,
       "Russell King" <linux@arm.linux.org.uk>,
       lkml <linux-kernel@vger.kernel.org>,
       "Haavard Skinnemoen" <hskinnemoen@atmel.com>
In-Reply-To: <alpine.LFD.1.10.0806231212320.2979@xanadu.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <alpine.LFD.1.10.0806231212320.2979@xanadu.home>
X-Google-Sender-Auth: 356d1ab956d86a54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 23, 2008 at 9:46 AM, Nicolas Pitre <nico@cam.org> wrote:
> Here is a driver for the DMA/XOR engine found on many ARM SoCs from
> Marvell, such as Orion and newly supported Kirkwood.  Could interested
> people (notably Maciej Sosnowski and Dan Williams who are listed as
> maintainers for the DMA generic offload subsystem) review this patch,
> and ultimately provide their ACK, so we could push this driver along
> with additional ARM patches that depend on this one through the ARM git
> tree.
>

Hi Nicolas,

With Haavard's recently posted changes there is more activity in the
dmaengine/async_tx space with implications to mv_xor.  What
difficulties arise if I carry mv_xor through async_tx.git instead of
letting it go though arm.git, i.e. what patches do you have that
depend on mv_xor?

Thanks,
Dan
