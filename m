Return-Path: <linux-kernel-owner+w=401wt.eu-S1754312AbZFCExG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754312AbZFCExG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jun 2009 00:53:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751805AbZFCEw4
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Jun 2009 00:52:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:53285 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751354AbZFCEwz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jun 2009 00:52:55 -0400
Message-ID: <4A26014F.4070207@zytor.com>
Date: Tue, 02 Jun 2009 21:51:27 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Thunderbird 2.0.0.14 (X11/20080501)
MIME-Version: 1.0
To: Gary Hade <garyhade@us.ibm.com>
CC: mingo@elte.hu, mingo@redhat.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, x86@kernel.org, ebiederm@xmission.com,
       yinghai@kernel.org, lcm@us.ibm.com
Subject: Re: [RESEND] [PATCH v2] [BUGFIX] x86/x86_64: fix CPU offlining	triggered
 "active" device IRQ interrruption
References: <20090602193216.GC7282@us.ibm.com>
In-Reply-To: <20090602193216.GC7282@us.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Gary Hade wrote:
> Impact: Eliminates an issue that can leave the system in an
>         unusable state.
> 
> This patch addresses an issue where device generated IRQs
> are no longer seen by the kernel following IRQ affinity
> migration while the device is generating IRQs at a high rate.
> 

This patch doesn't seem to apply to current mainline.

What is your base?

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

