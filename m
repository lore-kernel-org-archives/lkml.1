Return-Path: <linux-kernel-owner+w=401wt.eu-S933597AbXGQPqt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933597AbXGQPqt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 11:46:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934188AbXGQPmo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 11:42:44 -0400
Received: from cantor.suse.de ([195.135.220.2]:47489 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934684AbXGQPmm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 11:42:42 -0400
From: Andi Kleen <ak@suse.de>
Organization: SUSE Linux Products GmbH, Nuernberg, GF: Markus Rex, HRB 16746 (AG Nuernberg)
To: "Aaron Durbin" <adurbin@google.com>
Subject: Re: [PATCH] ACPI: Add reboot mechanism
Date: Tue, 17 Jul 2007 17:42:38 +0200
User-Agent: KMail/1.9.6
Cc: "Yinghai Lu" <yhlu.kernel@gmail.com>, linux-kernel@vger.kernel.org,
       linux-acpi@vger.kernel.org, len.brown@intel.com, akpm@osdl.org
References: <20070716180019.GA5112@google.com> <86802c440707170740i30ed2110l130dafbec8e4d4a5@mail.gmail.com> <8f95bb250707170808n19799ba5l3acd13e2ee7e0f08@mail.gmail.com>
In-Reply-To: <8f95bb250707170808n19799ba5l3acd13e2ee7e0f08@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200707171742.39067.ak@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 17 July 2007 17:08:19 Aaron Durbin wrote:
 
> This is true if SMIs are still flowing, and the SMI handler correctly handles
> the reset properly. I have seen cases where the SMI handler is broken which
> causes the system to perpetually hang.

Ah, that is the rationale that was missing in the first mail ...
Ok that makes some sense. Is it a common issue? 

-Andi
