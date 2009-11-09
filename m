Return-Path: <linux-kernel-owner+w=401wt.eu-S1753909AbZKID2D@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753909AbZKID2D (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Nov 2009 22:28:03 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753685AbZKID2C
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 8 Nov 2009 22:28:02 -0500
Received: from ozlabs.org ([203.10.76.45]:41891 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753461AbZKID2B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Nov 2009 22:28:01 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: =?utf-8?q?Andr=C3=A9_Goddard_Rosa?= <andre.goddard@gmail.com>
Subject: Re: [PATCH v4 01/12] vsprintf: factorize "(null)" string
Date: Mon, 9 Nov 2009 13:58:03 +1030
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; i686; ; )
References: <cover.1257602781.git.andre.goddard@gmail.com> <643e6260a571b533d8985b377a82410aded4ddae.1257602781.git.andre.goddard@gmail.com>
In-Reply-To: <643e6260a571b533d8985b377a82410aded4ddae.1257602781.git.andre.goddard@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <200911091358.03545.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 8 Nov 2009 01:46:09 am you wrote:
> Change "<NULL>" to "(null)" and make it a static const char[] hoping that
> the compiler will make null_str a label to a read-only area containing it.

(Trimmed the 79 recipients of the original).

Hi Andre,

Consistently using <NULL> or (null) makes sense.  But I'm really missing your argument: is there some reason why normal string merging won't work?

Confused,
Rusty.
