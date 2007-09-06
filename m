Return-Path: <linux-kernel-owner+w=401wt.eu-S1757885AbXIFRua@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757885AbXIFRua (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2007 13:50:30 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755198AbXIFRuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 6 Sep 2007 13:50:22 -0400
Received: from nz-out-0506.google.com ([64.233.162.233]:31155 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755095AbXIFRuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2007 13:50:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=K762jAM6kAAIFEXPAp3cVyGSmmwe8NKSPOdexfqbpQpvhUV3VGTivt6B4Idwxgk731omqQWqAGezjuRBHwjXPqbO7QxXbu12cezWZochySQgGNdwNyt76Ak/8K6ITEeAJUm3jggq6zMoRnvvtasZZTOLCsBwfjvEJNEGc8Olw2U=
Message-ID: <86802c440709061050x714a2bbbn776fb93cb46cdc49@mail.gmail.com>
Date: Thu, 6 Sep 2007 10:50:19 -0700
From: "Yinghai Lu" <yhlu.kernel@gmail.com>
To: "Jesse Barnes" <jesse.barnes@intel.com>
Subject: Re: [patches] [patch 3/5] x86: Add PCI extended config space access for AMD Barcelona
Cc: "H. Peter Anvin" <hpa@zytor.com>,
       "Arne Georg Gleditsch" <argggh@dolphinics.no>,
       "Andreas Herrmann" <andreas.herrmann3@amd.com>,
       "Robert Richter" <robert.richter@amd.com>,
       "Arjan van de Ven" <arjan@infradead.org>, patches@x86-64.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <200709061041.15488.jesse.barnes@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20070903081736.288288000@amd.com>
	 <kjmps0w9ou8.fsf@pelargir.dolphinics.no> <46DFCCD9.2010306@zytor.com>
	 <200709061041.15488.jesse.barnes@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/6/07, Jesse Barnes <jesse.barnes@intel.com> wrote:
> The problem with doing that is it would mean reserving some address
> space for mmconfig usage.  If the BIOS doesn't completely describe all
> the reserved regions via e820 or similar (apparently a common problem)
> we may end up making mmconfig overlap with another important area...
> It's pretty hard not to trust the BIOS here without completely
> replacing big chunks of it.

for Family 10h, you can use mmio range high beyond than the RAM
range...( just don't conflict with HT reserved range...)

YH
