Return-Path: <linux-kernel-owner+w=401wt.eu-S1755008AbYKLVLT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755008AbYKLVLT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2008 16:11:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752565AbYKLVLL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 12 Nov 2008 16:11:11 -0500
Received: from cantor.suse.de ([195.135.220.2]:44679 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752060AbYKLVLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2008 16:11:10 -0500
Date: Wed, 12 Nov 2008 22:11:06 +0100
From: Bernhard Walle <bwalle@suse.de>
To: "H. Peter Anvin" <hpa@kernel.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, kexec@lists.infradead.org
Subject: Re: [PATCH] Always use 64 bit addresses for the firmware memory map
Message-ID: <20081112221106.5d9d7801@kopernikus.site>
In-Reply-To: <491B358D.2040304@kernel.org>
References: <1226519089-21647-1-git-send-email-bwalle@suse.de>
	<491B358D.2040304@kernel.org>
Organization: SUSE Linux Products GmbH
X-Mailer: Claws Mail 3.6.1 (GTK+ 2.14.4; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* H. Peter Anvin [2008-11-12 11:59]:
> 
> I want to make sure, though, that we don't just end up pushing the
> truncation further down in the code.

Well, I think that interface should export the BIOS memmap as provided.
Since E820 does provide 64 bit addresses, that should get exported.

It should even possible to kexec a PAE kernel from a non PAE kernel ...
I didn't test, but it could work. But only if the E820 map is correctly
written in the zero page, which is only the case if we get it correctly.


Regards,
Bernhard
-- 
Bernhard Walle, SUSE LINUX Products GmbH, Architecture Development
