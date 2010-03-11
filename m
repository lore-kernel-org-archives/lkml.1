Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab0CKUFI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Mar 2010 15:05:08 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:18387 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752932Ab0CKUFG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Mar 2010 15:05:06 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Andrew Baumann <andrewb@cse.unsw.edu.au>
Subject: Re: PCI: Cannot allocate resource regions of bridge and device in ThinkPad dock
Date: Thu, 11 Mar 2010 13:05:04 -0700
User-Agent: KMail/1.9.10
Cc: linux-kernel@vger.kernel.org, Lara Michaels <laramichaels1978@yahoo.com>
References: <200607061345.31486.andrewb@cse.unsw.edu.au>
In-Reply-To: <200607061345.31486.andrewb@cse.unsw.edu.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201003111305.04989.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 05 July 2006 09:45:31 pm Andrew Baumann wrote:
> I'm unable to use a radeon card installed in the PCI slot of a thinkpad
> docking station. This is from a clean boot in the dock (no hot dock/undock),
> and appears on vendor-provided 2.6.16 and 2.6.17 kernels, as well as on a
> self-built 2.6.17-git25 tree.

Hi Andrew,

Did you ever get this ancient (2006!) issue resolved?  I didn't see
any responses on the list, and Lara is having a sort of similar issue:
  http://bugzilla.kernel.org/show_bug.cgi?id=15436

I think your problem was that Linux saw the Radeon card but didn't assign
resources correctly, while in Lara's case, Linux doesn't see the card at
all.

I suspect that your problem has been resolved in the meantime and that
Lara's might be broken hardware, but if yours is still broken, I'd like
to take a look at it.

Bjorn
