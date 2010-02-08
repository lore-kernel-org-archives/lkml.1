Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752024Ab0BHNdN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Feb 2010 08:33:13 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:46940 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744Ab0BHNdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Feb 2010 08:33:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=nv6m1lFP42gCNOfaZQbIGAgQX02aPXV7FyO/rYc1EPFe/BfKxv1EUAzc0k+li44UkB
         D3K8m807rDABcYi/aGBDcM78ECXYaATDAHCxwlvm7U5dhMqWRo8bugYAC/QlVAL9Tgct
         Zw1pP7JJTL9si0Jp397wg9/t8dJ3PPoprN5+0=
Message-ID: <4B701292.3030108@gmail.com>
Date: Mon, 08 Feb 2010 14:33:06 +0100
From: Artur Skawina <art.08.09@gmail.com>
User-Agent: Thunderbird 2.0.0.22pre (X11/20090422)
MIME-Version: 1.0
To: Michael Breuer <mbreuer@majjas.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Mike Galbraith <efault@gmx.de>, Arjan van de Ven <arjan@infradead.org>,
       Joerg Roedel <joro@8bytes.org>
Subject: Re: x86 - cpu_relax - why nop vs. pause?
References: <4B6EF853.9090704@majjas.com> <1265566470.6280.10.camel@marge.simson.net> <4B6F1DAE.6020407@majjas.com> <4B6F2D59.1070508@majjas.com> <4B6F8A02.2060006@majjas.com>
In-Reply-To: <4B6F8A02.2060006@majjas.com>
X-Enigmail-Version: 0.95.7
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Breuer wrote:
> Just to move away from this... totally perplexed, I retested a bit.
> Seems something else had gone wrong causing me to try 'rep;pause' vs.
> 'pause'. The resulting opcode is f3 f3 90, as noted above.
> 
> I do see what seems to be a small but noticeable performance improvement
> - no idea if there's a downside, and also no idea what f3 f3 90 does vs.
> f3 90. Might be something interesting, or maybe not.

Alignment? IOW what happens if you use eg "nop; rep; nop;" or "rep; nop; nop;"?
