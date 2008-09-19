Return-Path: <linux-kernel-owner+w=401wt.eu-S1755381AbYISV5U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755381AbYISV5U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 17:57:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753588AbYISV5H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 17:57:07 -0400
Received: from wa-out-1112.google.com ([209.85.146.176]:43113 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751498AbYISV5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 17:57:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=l2ENUr/CZelrqX0x+gAT6JTXw23FGntBIS9PXaTcomPCP/cF/+QjGkKnskPLIO1s9B
         v78cXliy+dxu4p9evNu8TkWTNnCAv9PYcttCpyZUgcRlsacclIcPsCSnBZggbk81UEox
         J/fbwOcEhpz4vGu4mBRLhhldVV+n+kOpBr7sY=
Message-ID: <84144f020809191457s447c8c2evbdf784a857c8f44e@mail.gmail.com>
Date: Sat, 20 Sep 2008 00:57:04 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Christoph Lameter" <cl@linux-foundation.org>
Subject: Re: [patch 0/3] Cpu alloc slub support: Replace percpu allocator in slub.c
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-mm@kvack.org, jeremy@goop.org, ebiederm@xmission.com,
       travis@sgi.com, herbert@gondor.apana.org.au, xemul@openvz.org
In-Reply-To: <20080919203703.312007962@quilx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <20080919203703.312007962@quilx.com>
X-Google-Sender-Auth: 92d2edc175db0043
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2008 at 11:37 PM, Christoph Lameter
<cl@linux-foundation.org> wrote:
> Slub also has its own per cpu allocator. Get rid of it and use cpu_alloc().

So, do you want to stick these into the slab tree? I would then need
to pick up the cpualloc patches as well, I suppose. Andrew, pls help.
