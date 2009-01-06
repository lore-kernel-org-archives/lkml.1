Return-Path: <linux-kernel-owner+w=401wt.eu-S1752166AbZAFJj1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752166AbZAFJj1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jan 2009 04:39:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754184AbZAFJjL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Jan 2009 04:39:11 -0500
Received: from nn7.de ([85.214.94.156]:46451 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754002AbZAFJjI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jan 2009 04:39:08 -0500
Subject: Re: Intel e1000e: eth0: Detected Tx Unit Hang
From: Soeren Sonnenburg <kernel@nn7.de>
To: Jesse Brandeburg <jesse.brandeburg@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
       e1000-devel@lists.sourceforge.net
In-Reply-To: <1231227283.7107.27.camel@localhost>
References: <1230839773.8319.12.camel@localhost>
	 <4807377b0901051638r7b31ac62r2165bbe589c04a50@mail.gmail.com>
	 <1231227283.7107.27.camel@localhost>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Tue, 06 Jan 2009 10:39:01 +0100
Message-Id: <1231234741.7107.43.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-01-06 at 08:34 +0100, Soeren Sonnenburg wrote:
> On Mon, 2009-01-05 at 16:38 -0800, Jesse Brandeburg wrote:
> > On Thu, Jan 1, 2009 at 11:56 AM, Soeren Sonnenburg <kernel@nn7.de> wrote:
> > > Dear list,
[...]
> > also, please double check you're running the latest BIOS for your motherboard.
> 
> indeed there seems to be an update to version 1.06 for this mainboard
> (DP45SG), so hopefully this goes away
> 
> $ dmesg | grep -i calg
> 
> Calgary: detecting Calgary via BIOS EBDA area
> Calgary: Unable to locate Rio Grande table in EBDA - bailing!
> 
> $ dmesg | grep -i bug
> pci 0000:00:1a.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
> pci 0000:00:1d.7: EHCI: BIOS handoff failed (BIOS bug?) 01010001
> 
> even though I don't find any insight in the changelog:
> 
> http://downloadmirror.intel.com/17218/eng/SG_0106_ReleaseNotes.pdf

Nope, same error messages in dmesg with the latest bios.

Soeren.
