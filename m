Return-Path: <linux-kernel-owner+w=401wt.eu-S934313AbXFFFKh@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934313AbXFFFKh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2007 01:10:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755171AbXFFFK1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jun 2007 01:10:27 -0400
Received: from wr-out-0506.google.com ([64.233.184.229]:63025 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752051AbXFFFKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2007 01:10:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=sVrVlhYndVOUQgXuuFdeIrME+kGj3uqQmE07c6W68Ws7FIgWveaqrQRBYsRgXiZOJdSAP73hhxOD+uDSk75cw0YmCkxI7v51pZAdjOJfTeZxZL3LbN3/D0Y6Ndjx1QesQ9uV93gDv2UlvQs/3qwSrJCJW6vQD0aoRZl4/NSlbGs=
Message-ID: <a8e1da0706052210v2727b306s95f8a3212d8a3db5@mail.gmail.com>
Date: Wed, 6 Jun 2007 05:10:24 +0000
From: "young dave" <hidave.darkstar@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: [patch -mm] alsa mixer_oss kfree fix
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>,
       "Jaroslav Kysela" <perex@suse.cz>
In-Reply-To: <20070531191005.292efbdc.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <a8e1da0705311853w4df1aae8k87c55fdfbfa96b10@mail.gmail.com>
	 <20070531191005.292efbdc.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Andrew


> kfree(NULL) is legal, and is often used.
>

Apart from the null pointer, IMHO,there's two problem need to be
fixed, I'm not sure.

What's your opinion?

1. the label indent should be removed
2. similar code use different label, some use " __unlock" but others
use "__unalloc", "__unlock" seems to be misspelled.

Regards
dave
