Return-Path: <linux-kernel-owner+w=401wt.eu-S1756988AbZLOISm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756988AbZLOISm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Dec 2009 03:18:42 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752204AbZLOISl
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Dec 2009 03:18:41 -0500
Received: from hera.kernel.org ([140.211.167.34]:46815 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752162AbZLOISk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Dec 2009 03:18:40 -0500
Message-ID: <4B274694.6020701@kernel.org>
Date: Tue, 15 Dec 2009 17:19:32 +0900
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.1.1 Thunderbird/3.0
MIME-Version: 1.0
To: Krzysztof Halasa <khc@pm.waw.pl>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: SATA_SIL: Add a work-around for IXP4xx CPU.
References: <m3fx8m0vwh.fsf@intrepid.localdomain>
In-Reply-To: <m3fx8m0vwh.fsf@intrepid.localdomain>
X-Enigmail-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 11/11/2009 09:04 AM, Krzysztof Halasa wrote:
> IXP4xx CPUs can't read from 8 and 16-bit PCI MMIO registers, we have to read
> from normal IO regions instead.
> 
> Tested on SIL3512, and specifically not tested on 4-port SIL3114.
> 
> Signed-off-by: Krzysztof Hałasa <khc@pm.waw.pl>

Hmmm... Given that there are some platforms which have problem with
mmio and sil3112/4 can do everything via io accesses, it would be nice
to generalize this so that there's CONFIG_SATA_SIL_NO_MMIO which is
selected by affected platforms.  Are you interested in doing it?

Thanks.

-- 
tejun
