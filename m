Return-Path: <linux-kernel-owner+w=401wt.eu-S1756915AbYFLVo1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756915AbYFLVo1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2008 17:44:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752246AbYFLVoR
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 12 Jun 2008 17:44:17 -0400
Received: from rv-out-0506.google.com ([209.85.198.238]:31613 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751481AbYFLVoQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2008 17:44:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=qn3N4LVa7jwH+toPtlgpBuzlbZ/ntOyv7+gTuBn/GOYVtqhRX8PxKT/ogRcvkNWc6H
         MKQx54f11zPNLPk7SEtqhvzuLWmaMOvRDG+av92iE1lfqDLMvkYB6TJF6YAqTB6Au18n
         nXaUVNfOa9xHmANoWTBvVpm1s/khFl5DY3qKQ=
Message-ID: <84144f020806121444i43d381ehdee1774c135d8841@mail.gmail.com>
Date: Fri, 13 Jun 2008 00:44:13 +0300
From: "Pekka Enberg" <penberg@cs.helsinki.fi>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: [PATCH] ssb: Fix coherent DMA mask for PCI devices
Cc: "John Linville" <linville@tuxdriver.com>, linux-wireless@vger.kernel.org,
       netdev@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>,
       "Kirill A. Shutemov" <kirill@shutemov.name>,
       "Glauber Costa" <gcosta@redhat.com>
In-Reply-To: <200806121533.14435.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200806121533.14435.mb@bu3sch.de>
X-Google-Sender-Auth: 79e40db10bf75ff7
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 12, 2008 at 4:33 PM, Michael Buesch <mb@bu3sch.de> wrote:
> This fixes setting the coherent DMA mask for PCI devices.
>
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
>
> ---
>
> John, please queue this bugfix for 2.6.26
>
> The whole SSB DMA API should be rewritten, as it makes too many bad
> assumptions about the other subsytems. I will do that soon.
> But let's apply this patch for now, as it fixes this particular bug.

Hmm. Does the patch have anything to do with this bug report?

http://bugzilla.kernel.org/show_bug.cgi?id=10819
