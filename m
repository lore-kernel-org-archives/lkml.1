Return-Path: <linux-kernel-owner+w=401wt.eu-S1754662AbYDXIjp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbYDXIjp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2008 04:39:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751298AbYDXIjg
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 Apr 2008 04:39:36 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:50796 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751262AbYDXIjg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2008 04:39:36 -0400
Subject: Re: [PATCH] x86: vm86 - hide X86_VM_MASK from userland programs
From: David Woodhouse <dwmw2@infradead.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20080424083558.GA7749@cvg>
References: <20080424083558.GA7749@cvg>
Content-Type: text/plain
Date: Thu, 24 Apr 2008 09:39:24 +0100
Message-Id: <1209026364.9212.978.camel@pmac.infradead.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.1 (2.22.1-1.fc9) 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by pentafluge.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-04-24 at 12:35 +0400, Cyrill Gorcunov wrote:
> X86_VM_MASK is a kernel specific flag so lets hide it from
> userland programs
> 
> Signed-off-by: Cyrill Gorcunov <gorcunov@gmail.com>

Since and there's already an #ifdef __KERNEL__ section later on in the
file, and since X86_VM_MASK isn't used before that, I probably would
have been inclined to shift it down there instead of adding a new
#ifdef.

But maybe I should just stop heckling... :)

-- 
dwmw2

