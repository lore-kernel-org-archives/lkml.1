Return-Path: <linux-kernel-owner+w=401wt.eu-S1756425AbZJGXrN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425AbZJGXrN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Oct 2009 19:47:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755183AbZJGXrN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 7 Oct 2009 19:47:13 -0400
Received: from mail-px0-f179.google.com ([209.85.216.179]:57316 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754649AbZJGXrM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Oct 2009 19:47:12 -0400
MIME-Version: 1.0
In-Reply-To: <7a2a686d-ddf4-4a42-8c73-c933cebf22a4@VA3EHSMHS005.ehs.local>
References: <1d3f23370910070013u6307bc42hf7ab243b52d007df@mail.gmail.com>
	 <fa686aa40910070634r4a8dcf74qdcbfb3bde3413109@mail.gmail.com>
	 <838c3c32-27d9-4a0a-a197-c7227b911942@VA3EHSMHS014.ehs.local>
	 <1d3f23370910071641s75b2d217h71a839b1a0b4013c@mail.gmail.com>
	 <7a2a686d-ddf4-4a42-8c73-c933cebf22a4@VA3EHSMHS005.ehs.local>
Date: Thu, 8 Oct 2009 09:46:36 +1000
Message-ID: <1d3f23370910071646la1ac12ds7c2805f1569cd9e6@mail.gmail.com>
Subject: Re: Xilinx SYSACE driver and 8-bit attachment
From: John Williams <john.williams@petalogix.com>
To: John Linn <John.Linn@xilinx.com>
Cc: grant.likely@secretlab.ca,
       Linux Kernel list <linux-kernel@vger.kernel.org>,
       Michal Simek <michal.simek@petalogix.com>,
       David DeBonis <ddeboni@xilinx.com>,
       Stephen Neuendorffer <stephenn@xilinx.com>,
       devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi John,


On Thu, Oct 8, 2009 at 9:44 AM, John Linn <John.Linn@xilinx.com> wrote:
> I fixed the device tree generator and checked into git-dev, I'll push it out soon after a little more test time.

I think we should be careful about adding special per-device handing
in the DTS generator.  Where ever possible I would encourage generic
handling.  Most Xilinx devices are "green fields" with respect to the
device tree binding and these params, SystemACE is a little different
because it's been in mainline longer and has users outside the DTS
generator flow.

John
-- 
John Williams, PhD, B.Eng, B.IT
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com  p: +61-7-30090663  f: +61-7-30090663
