Return-Path: <linux-kernel-owner+w=401wt.eu-S1757540AbZJBMof@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540AbZJBMof (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 08:44:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756825AbZJBMof
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 08:44:35 -0400
Received: from mail-ew0-f211.google.com ([209.85.219.211]:54738 "EHLO
	mail-ew0-f211.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756808AbZJBMoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Oct 2009 08:44:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=W77EYtS/ok0kcTzn6GSDnZ3LT6NN+luUI3mpGiJlFCd6rH+d+GKOrgEFjbtmcmDJpV
         99HE9XRRCrYnbsoiN6N7bOuOCReW3KHoMbhbLalr6y1u3GeJSBmiAP23e1qtzEGnqMlj
         YIjv1ctZhcqResoFXC2Q2H2r4UBY5Jhz8pPzk=
Message-ID: <4AC5F59C.5090507@gmail.com>
Date: Fri, 02 Oct 2009 16:44:12 +0400
From: Ilya Yanok <ilya.yanok@gmail.com>
User-Agent: Mozilla-Thunderbird 2.0.0.19 (X11/20090103)
MIME-Version: 1.0
To: Jan Beulich <JBeulich@novell.com>
CC: adaplas@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: commit 68e5e9d734503695915734e50e9427624cf8f3b2 (Re: vfb: make
  virtual framebuffer mmapable)
References: <4AC5EFC50200007800017ABC@vpn.id2.novell.com>
In-Reply-To: <4AC5EFC50200007800017ABC@vpn.id2.novell.com>
X-Enigmail-Version: 0.95.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jan,

Jan Beulich wrote:
> Is there any particular reason why this change uses vmalloc_32()
> rather than simply vmalloc()?

I don't think so. I wasn't very experienced with kernel programming that
time and just copied code from another driver. Actually I think we don't
really need all this rvmalloc()/rvfree() magic we just need to use
remap_vmalloc_range() instead of remap_pfn_range().

Regards, Ilya.

