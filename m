Return-Path: <linux-kernel-owner+w=401wt.eu-S1762485AbXEOTjn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762485AbXEOTjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2007 15:39:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757676AbXEOThz
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 May 2007 15:37:55 -0400
Received: from smtp2.linux-foundation.org ([207.189.120.14]:41199 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757682AbXEOThw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2007 15:37:52 -0400
Date: Tue, 15 May 2007 12:37:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "Peter Oruba" <peter.oruba@amd.com>
Cc: gregkh@suse.de, cramerj@intel.com, john.ronciak@intel.com,
       jesse.brandeburg@intel.com, jeffrey.t.kirsher@intel.com,
       auke-jan.h.kok@intel.com, rolandd@cisco.com, halr@voltaire.com,
       linux-driver@qlogic.com,
       "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Stephen Hemminger" <shemminger@linux-foundation.org>
Subject: Re: [PATCH 0/2] PCI-X/PCI-Express read control interfaces
Message-Id: <20070515123721.1bfb02a3.akpm@linux-foundation.org>
In-Reply-To: <200705151350.28330.peter.oruba@amd.com>
References: <200705151350.28330.peter.oruba@amd.com>
X-Mailer: Sylpheed version 2.2.7 (GTK+ 2.8.6; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 May 2007 13:50:27 +0200
"Peter Oruba" <peter.oruba@amd.com> wrote:

> This patch set introduces a PCI-X / PCI-Express read byte count control 
> interface. Instead of letting every driver to directly read/write to PCI 
> config space for that, an interface is provided. The interface functions then 
> can be used for quirks since some PCI bridges require that read byte count 
> values are set by the BIOS and left unchanged by device drivers.

Some of the patches were wordwrapped, which I fixed.

The way we would merge a feature like this is

- get maintainers to review-and-ack the change

- merge the core patch into Greg's PCI tree and later into
  mainline.

- Once the base infrastructure is in mainline, feed the per-driver
  changes into the tree via the appropriate maintainers.

This takes, umm, months and consumes quite a bit of my time.  I'm becoming
inclined just to slam stuff like this straight in as you've proposed, but
for now, let's play the game - I split the patches up appropriately.  I
don't think there's any particular urgency behind this, is there?

