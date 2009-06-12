Return-Path: <linux-kernel-owner+w=401wt.eu-S1759334AbZFLUr2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759334AbZFLUr2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jun 2009 16:47:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756943AbZFLUrU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 12 Jun 2009 16:47:20 -0400
Received: from fg-out-1718.google.com ([72.14.220.153]:33324 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715AbZFLUrT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jun 2009 16:47:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=IYs9I3OMnfKt9tr6bpZta2gKehBOhsiWc/iJYsMx0n/OrH5VyvNCvw+aIRbGotkjlw
         gxm69BXTzG4ilKmM+XeTUEDBL/PNoMUhdXPQyOce9Cd+ROGmCwkF09gS6uXuiggBkB22
         w9FpKViLGgC93ai+4R+Ou30AJiyJ7k7YGpkYU=
Message-ID: <4A32BED7.1070100@gmail.com>
Date: Fri, 12 Jun 2009 22:47:19 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.4 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: mm-commits@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       npiggin@suse.de, penberg@cs.helsinki.fi
Subject: Re: mmotm 2009-06-12-12-20 uploaded
References: <200906121940.n5CJekrh001446@imap1.linux-foundation.org>
In-Reply-To: <200906121940.n5CJekrh001446@imap1.linux-foundation.org>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/12/2009 09:20 PM, akpm@linux-foundation.org wrote:
> The mm-of-the-moment snapshot 2009-06-12-12-20 has been uploaded to

Hi, it doesn't build with SLQB:
init/built-in.o: In function `start_kernel':
(.init.text+0x73e): undefined reference to `kmem_cache_init_late'
make[1]: *** [.tmp_vmlinux1] Error 1
make: *** [sub-make] Error 2

SLQB doesn't define that function (opposing to other slab allocators).
