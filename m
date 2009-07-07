Return-Path: <linux-kernel-owner+w=401wt.eu-S1755551AbZGGFBf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbZGGFBf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jul 2009 01:01:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751672AbZGGFB0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 7 Jul 2009 01:01:26 -0400
Received: from ozlabs.org ([203.10.76.45]:43170 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbZGGFBZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jul 2009 01:01:25 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Jan Beulich" <JBeulich@novell.com>
Subject: Re: [PATCH 2/2] reduce string table for loaded modules (v2)
Date: Tue, 7 Jul 2009 14:31:25 +0930
User-Agent: KMail/1.11.2 (Linux/2.6.28-13-generic; KDE/4.2.2; i686; ; )
Cc: linux-kernel@vger.kernel.org
References: <4A521D900200007800008F97@vpn.id2.novell.com>
In-Reply-To: <4A521D900200007800008F97@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200907071431.25666.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jul 2009 11:21:44 pm Jan Beulich wrote:
> Also remove all parts of the string table (referenced by the symbol
> table) that are not needed for kallsyms use (i.e. which were only
> referenced by symbols discarded by the previous patch, or not
> referenced at all for whatever reason).

Thanks, these two applied!

Cheers,
Rusty.
