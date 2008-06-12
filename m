Return-Path: <linux-kernel-owner+w=401wt.eu-S1756656AbYFLBS0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656AbYFLBS0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2008 21:18:26 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754901AbYFLBSP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 11 Jun 2008 21:18:15 -0400
Received: from ti-out-0910.google.com ([209.85.142.188]:42990 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753826AbYFLBSN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2008 21:18:13 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=i68IQFjynHHinLMdnoN76qamJYaFCG/QABTiuW+8hZA//sdyOcClJtZ58In9/8sQs2
         mNgm5l7aFRXFw9wTE4NW23yI8oZhMGoYOjcsvg27jvqkFpxlAOVZYT3jWNEME8KGMPIi
         eOVYY0+7oBsMLdIuhFkcK5kC11lrbv2coAYe8=
Message-ID: <4850794F.3000200@gmail.com>
Date: Thu, 12 Jun 2008 10:18:07 +0900
From: Tejun Heo <htejun@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Justin Mattock <justinmattock@gmail.com>
CC: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       linux-ide@vger.kernel.org
Subject: Re: macbook pro dvd playback after suspend Buffer I/O error
References: <dd18b0c30804032207u36bd1f43l358e9949f0c94f79@mail.gmail.com>	 <20080404012147.abf8a598.akpm@linux-foundation.org>	 <484F31B8.8030001@gmail.com>	 <dd18b0c30806110045s6d19a034yd89b892441bd1621@mail.gmail.com>	 <dd18b0c30806111131gc1b506cva12f577ebb4afdf9@mail.gmail.com>	 <485048EC.2080608@gmail.com> <dd18b0c30806111527x22fa895em230ceade4712f073@mail.gmail.com>
In-Reply-To: <dd18b0c30806111527x22fa895em230ceade4712f073@mail.gmail.com>
X-Enigmail-Version: 0.95.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Justin Mattock wrote:
> O.K. attached is dmesg of playing a dvd, then suspending and wakingup,
> as well as starting after the buffer error.(audit messages)
> This is interesting, even  pausing the dvd before suspending, causes
> the same error.
> I sent a post to mplayer-users to see if there is a way to have
> mplayer pause and wait for the disk drive to align, but am still
> waiting
> for a response.

Can you please do the followings?

1. dd if=/dev/sr0 of=/dev/null bs=1M
2. suspend / resume
3. see whether dd fails and post the resulting dmesg.

Thanks.

-- 
tejun
