Return-Path: <linux-kernel-owner+w=401wt.eu-S1757941AbZGQWKv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757941AbZGQWKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jul 2009 18:10:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757912AbZGQWKu
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Jul 2009 18:10:50 -0400
Received: from mail-gx0-f213.google.com ([209.85.217.213]:44523 "EHLO
	mail-gx0-f213.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986AbZGQWKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jul 2009 18:10:49 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ZnxOc9uuIMz4OPDbFZi1mTsgmjjY1wOsb71FLZuxGkdZvAv3OEYLUlQW1RHsRdaAN/
         odwVpoPfkVpTYqB2c4L2UU/WjnmHg5dtayf30GOoGykAFzvRooFNXtXy9DKrpzVBvPFs
         aUnYv2rUbq7K++ZmQZNNPcz0iRiz4hK6ibgYs=
MIME-Version: 1.0
In-Reply-To: <20090714165830.GF31657@tpkurt2.suse.de>
References: <20090518093352.GC15531@tpkurt2.garloff.de>
	 <20090622140522.GA5378@sgi.com>
	 <20090714165508.GD31657@tpkurt2.suse.de>
	 <20090714165830.GF31657@tpkurt2.suse.de>
Date: Fri, 17 Jul 2009 15:10:48 -0700
Message-ID: <86802c440907171510r724a02c6h641529cced061823@mail.gmail.com>
Subject: Re: [PATCH 2/3] Resend: x86-64: Handle SRAT v1 and v2 consistently
From: Yinghai Lu <yhlu.kernel@gmail.com>
To: Kurt Garloff <garloff@suse.de>,
       Linux kernel list <linux-kernel@vger.kernel.org>,
       Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 14, 2009 at 9:58 AM, Kurt Garloff<garloff@suse.de> wrote:
> Hi,
>
> In SRAT v1, we had 8bit proximity domain (PXM) fields; SRAT v2 provides
> 32bits for these. The new fields were reserved before.
> According to the ACPI spec, the OS must disregard reserved fields.
>
> x86-64 was rather inconsistent prior to this patch; it used 8 bits
> for the pxm field in cpu_affinity, but 32 bits in mem_affinity.
> This patch makes it consistent: Either use 8 bits consistently (SRAT
> rev 1 or lower) or 32 bits (SRAT rev 2 or higher).
>
> This is patch 2/3.
>
> Signed-off-by: Kurt Garloff <garloff@suse.de>
> --

for 1, 2

Acked-by: Yinghai Lu <yinghai@kernel.org>

YH
