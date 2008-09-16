Return-Path: <linux-kernel-owner+w=401wt.eu-S1756617AbYIPRuo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756617AbYIPRuo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Sep 2008 13:50:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753302AbYIPRug
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 16 Sep 2008 13:50:36 -0400
Received: from yw-out-2324.google.com ([74.125.46.29]:59709 "EHLO
	yw-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752838AbYIPRuf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Sep 2008 13:50:35 -0400
From: David Sanders <linux@sandersweb.net>
Reply-To: linux@sandersweb.net
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: Don't use NOPL on 32-bit cpu's because not all systems support it.
Date: Tue, 16 Sep 2008 13:50:30 -0400
User-Agent: KMail/1.9.5
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
       the arch/x86 maintainers <x86@kernel.org>, Ingo Molnar <mingo@elte.hu>
References: <200809161159.15870.linux@sandersweb.net> <48CFDF82.3000704@zytor.com> <20080916180022.5f57368b@lxorguk.ukuu.org.uk>
In-Reply-To: <20080916180022.5f57368b@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200809161350.31521.linux@sandersweb.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 16 September 2008 13:00, Alan Cox wrote:
> > Given that, we should either just rip this code out, or detect VPC
> > (how?).  The latter option can be done post-.27, of course; if so, we
>
> Make the user pass a "vpcworkarounds" boot option...
Actually, you can pass noreplace-paravirt, but that is non-obvious to the 
regular user.
