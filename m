Return-Path: <linux-kernel-owner+w=401wt.eu-S1755621AbZHKXRu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755621AbZHKXRu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Aug 2009 19:17:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755605AbZHKXRt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Aug 2009 19:17:49 -0400
Received: from mga09.intel.com ([134.134.136.24]:26566 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755599AbZHKXRs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Aug 2009 19:17:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.43,363,1246863600"; 
   d="scan'208";a="438155136"
Date: Tue, 11 Aug 2009 16:17:46 -0700
From: Jesse Barnes <jesse.barnes@intel.com>
To: Dave Airlie <airlied@gmail.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-kernel@vger.kernel.org, dri-devel@lists.sf.net,
       Tiago Vignatti <tiago.vignatti@nokia.com>
Subject: Re: [PATCH] vga: implements VGA arbitration on Linux
Message-ID: <20090811161746.7b8878aa@jbarnes-g45>
In-Reply-To: <1249969927-884-1-git-send-email-airlied@gmail.com>
References: <1249969927-884-1-git-send-email-airlied@gmail.com>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.17.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Aug 2009 15:52:06 +1000
Dave Airlie <airlied@gmail.com> wrote:

> From: Tiago Vignatti <tiago.vignatti@nokia.com>
> 
> Background:
> Graphic devices are accessed through ranges in I/O or memory space.
> While most modern devices allow relocation of such ranges, some
> "Legacy" VGA devices implemented on PCI will typically have the same
> "hard-decoded" addresses as they did on ISA. For more details see
> "PCI Bus Binding to IEEE Std 1275-1994 Standard for Boot
> (Initialization Configuration) Firmware Revision 2.1" Section 7,
> Legacy Devices.
> 
> The Resource Access Control (RAC) module inside the X server
> currently does the task of arbitration when more than one legacy
> device co-exists on the same machine. But the problem happens when
> these devices are trying to be accessed by different userspace
> clients (e.g. two server in parallel). Their address assignments
> conflict. Therefore an arbitration scheme _outside_ of the X server
> is needed to control the sharing of these resources. This document
> introduces the operation of the VGA arbiter implemented for Linux
> kernel.
> 
> Signed-off-by: Tiago Vignatti <tiago.vignatti@nokia.com>
> Signed-off-by: Dave Airlie <airlied@redhat.com>

Ok, applied this to my linux-next branch, but I'd like to get Ben's
s-o-b before pushing it to Linus.

Ben?

Thanks,
-- 
Jesse Barnes, Intel Open Source Technology Center
