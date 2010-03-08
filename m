Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754316Ab0CHL0i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Mar 2010 06:26:38 -0500
Received: from cantor.suse.de ([195.135.220.2]:48463 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754154Ab0CHL0g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Mar 2010 06:26:36 -0500
From: Thomas Renninger <trenn@suse.de>
Organization: SUSE Products GmbH
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86 apic: Ack all pending irqs when crashed/on kexec
Date: Mon, 8 Mar 2010 12:26:34 +0100
User-Agent: KMail/1.12.4 (Linux/2.6.31.12-0.1-desktop; KDE/4.3.5; x86_64; ; )
Cc: Kerstin Jonsson <kerstin.jonsson@ericsson.com>, jbohac@novell.com,
       "Yinghai Lu" <yinghai@kernel.org>, akpm@linux-foundation.org,
       mingo@elte.hu, "Avi Kivity" <avi@redhat.com>
References: <1268047030-29911-1-git-send-email-trenn@suse.de>
In-Reply-To: <1268047030-29911-1-git-send-email-trenn@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-6"
Content-Transfer-Encoding: 7bit
Message-Id: <201003081226.34583.trenn@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 March 2010 12:17:10 Thomas Renninger wrote:
> From: Kerstin Jonsson <kerstin.jonsson@ericsson.com>
> 
> When the SMP kernel decides to crash_kexec() the local APICs may have
> pending interrupts in their vector tables.
...
Sorry, indentation is totally messed up, I resend another version
which is "checkpatch'ed"
If this is an acceptable approach, it would be great if Kerstin
could try out and test the "break out after 1 sec" condition and
whether all still works as expected...

Thanks,

  Thomas
