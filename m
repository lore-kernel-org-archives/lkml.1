Return-Path: <linux-kernel-owner+w=401wt.eu-S1754761AbZGHLkH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761AbZGHLkH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jul 2009 07:40:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753349AbZGHLj4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 8 Jul 2009 07:39:56 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:48800 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271AbZGHLj4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jul 2009 07:39:56 -0400
Date: Wed, 8 Jul 2009 12:39:49 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alexey Fisher <bug-track@fisher-privat.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       "Richard A. Holden III" <aciddeath@gmail.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: Intel BIOS - Corrupted low memory at ffff880000004200
Message-ID: <20090708113949.GA8960@srcf.ucam.org>
References: <4A5210A2.2080301@fisher-privat.net> <4A52254F.8080103@fisher-privat.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A52254F.8080103@fisher-privat.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 06, 2009 at 06:24:47PM +0200, Alexey Fisher wrote:
> Hallo Ingo, Richard.
>
> I'm getting "Corrupted low memory" trace with my Intel DG45ID board
> after resume. This board  has different dmi-bios-vendor... so probably
> it will be nice to have it in your patch.

I'm beginning to think that we should be doing this on all hardware, 
perhaps with a kernel option to disable it for embedded devices that 
really need that 64K. The low-memory corruption issue seems to be very 
widespread.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
