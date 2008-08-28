Return-Path: <linux-kernel-owner+w=401wt.eu-S1753619AbYH1KRd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619AbYH1KRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2008 06:17:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751515AbYH1KRV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 28 Aug 2008 06:17:21 -0400
Received: from yx-out-2324.google.com ([74.125.44.29]:59000 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751371AbYH1KRU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2008 06:17:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=ajFlSYM5jRi9d7IFPFZVS7UOoKfbdvDBc0AQyaFMhoVmZ0HpYYEe0XhJfLm8PI8+7H
         42zJalPT7SznEZIiBgN3zKnYvwR+/4ecEitY5UKYWED9OhHQvpIyfErAiTtBM+HsxBjE
         tTgX7bmqAeLZPC8LbfkbAv2n8z6tJySC6sfEk=
Message-ID: <ef1cd66f0808280317r72f98402x5f4c23bf4aaf100d@mail.gmail.com>
Date: Thu, 28 Aug 2008 11:17:19 +0100
From: "=?ISO-8859-1?Q?Jochen_Vo=DF?=" <jochen.voss@googlemail.com>
To: "Jeff Kirsher" <jeffrey.t.kirsher@intel.com>
Subject: Re: [PATCH] e1000: fix stack size
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
       davem@davemloft.net, akpm@linux-foundation.org,
       "Linus Torvalds" <torvalds@linux-foundation.org>
In-Reply-To: <20080827081446.9269.19136.stgit@jtkirshe-mobile.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080827081446.9269.19136.stgit@jtkirshe-mobile.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2008/8/27 Jeff Kirsher <jeffrey.t.kirsher@intel.com>:
> From: Linus Torvalds <torvalds@linux-foundation.org>
>
> Here's the patch. It shrinks the stack from 1152 bytes to 192 bytes (the
> first version, that only did the e1000_option part, got it down to 600
> bytes). About half comes from not using multiple "e1000_option"
> structures, the other half comes from turning the "e1000_opt_list[]"
> arrays into "static const" instead, so that gcc doesn't copy them onto the
> stack.
>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Reveiewed-by: Auke Kok <auke-jan.h.kok@intel.com>
  ^^^^^^^^^^^^^^
  typo here

> Tested-by: Emil Tantilov <emil.s.tantilov@intel.com>
> Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

I hope this helps,
Jochen
-- 
http://seehuhn.de/
