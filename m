Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab0BWMBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Feb 2010 07:01:14 -0500
Received: from cantor.suse.de ([195.135.220.2]:45620 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751710Ab0BWMBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Feb 2010 07:01:13 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 apic: Ack all pending irqs when crashed/on kexec
Date: Tue, 23 Feb 2010 13:01:11 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.32.1-0.0.14.f17927a-desktop; KDE/4.3.1; x86_64; ; )
Cc: Kerstin Jonsson <kerstin.jonsson@ericsson.com>, jbohac@novell.com,
       "Yinghai Lu" <yinghai@kernel.org>, akpm@linux-foundation.org,
       mingo@elte.hu
References: <1266925885-17616-1-git-send-email-trenn@suse.de>
In-Reply-To: <1266925885-17616-1-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201002231301.11372.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 February 2010 12:51:25 Thomas Renninger wrote:
> From: Kerstin Jonsson <kerstin.jonsson@ericsson.com>
...
> +	int i, j, acked = 0, max_loops = cpu_khz * 1000;
Grmpfl, an unsigned long for max_loops, probably is a better idea...
What do you think, could this one get picked up then, anything else
to improve?

Thanks,

      Thomas
