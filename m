Return-Path: <linux-kernel-owner+w=401wt.eu-S934203AbYAaWK0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203AbYAaWK0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:10:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758274AbYAaWKR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:10:17 -0500
Received: from terminus.zytor.com ([198.137.202.10]:54876 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702AbYAaWKP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:10:15 -0500
Message-ID: <47A24615.4060603@zytor.com>
Date: Thu, 31 Jan 2008 14:05:09 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.9 (X11/20071115)
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Arjan van de Ven <arjan@infradead.org>,
       Jan Engelhardt <jengelh@computergmbh.de>, linux-kernel@vger.kernel.org,
       davej@redhat.com, mingo@elte.hu, tglx@tglx.de
Subject: Re: [PATCH] x86: introduce /dev/mem restrictions with a config option
References: <20080130124853.184ef782@laptopd505.fenrus.org> <20080131090839.7f610a6a@laptopd505.fenrus.org> <47A2086F.2040501@zytor.com> <200801311402.46833.jbarnes@virtuousgeek.org>
In-Reply-To: <200801311402.46833.jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jesse Barnes wrote:
>>> This is more for compatibility with legacy X
>> Legacy X, and non-BAR X memory (originally ISA, of course; now
>> probably more often "stolen system memory").
> 
> For legacy memory, we actually have /sys/bus/pci/<busno>/legacy_mem 
> (though ia64 may be the only supported platform).  It's actually 
> required on some arches due to the way this space is allocated across 
> the system.

Well, it's certainly not under /sys/bus/pci on x86 systems...

	-hpa
