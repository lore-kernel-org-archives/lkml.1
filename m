Return-Path: <linux-kernel-owner+w=401wt.eu-S2992953AbXDTNKE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992953AbXDTNKE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2007 09:10:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S2992763AbXDTNKE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Apr 2007 09:10:04 -0400
Received: from cantor.suse.de ([195.135.220.2]:48411 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S2992953AbXDTNKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2007 09:10:03 -0400
To: guilherme <guilherme@centralinf.com.br>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.21-rc7: HPET enabled freeze my machine at boot
References: <4628B0DA.3070907@centralinf.com.br>
From: Andi Kleen <andi@firstfloor.org>
Date: 20 Apr 2007 16:08:03 +0200
In-Reply-To: <4628B0DA.3070907@centralinf.com.br>
Message-ID: <p73mz133zr0.fsf@bingen.suse.de>
User-Agent: Gnus/5.09 (Gnus v5.9.0) Emacs/21.3
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

guilherme <guilherme@centralinf.com.br> writes:

> Sorry, i put the wrong option in the last mail.
> The options that freeze my machine at boot is "HPET Timer Support".

Either an interrupt routing problem or your HPET timer is broken.

Does it work with noapic? 

Can you describe your hardware? dmidecode/lspci/acpidmp?

-Andi

