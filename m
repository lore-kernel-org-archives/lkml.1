Return-Path: <linux-kernel-owner+w=401wt.eu-S1757180AbZCBKde@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757180AbZCBKde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Mar 2009 05:33:34 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757707AbZCBKdP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Mar 2009 05:33:15 -0500
Received: from mail-fx0-f176.google.com ([209.85.220.176]:37695 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757591AbZCBKdO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Mar 2009 05:33:14 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ZXDH1WOorYYhCOEOO+dLtqqq0bmQBg8nS8fOWpx8Gg2WYqVR+twPCp+fMtcg549+kz
         hZcelAg9LzUu/3LqBr37fcMsghe7ufYVHdCq28f2SeemhD5tS3SQySpRGSz5vrqxi4v7
         IC5FYiB+/G45ZdWyYYUv2UBsO4QelPukIl2K8=
Message-ID: <49ABB5E5.2080408@gmail.com>
Date: Mon, 02 Mar 2009 11:33:09 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1b3pre) Gecko/20090223 SUSE/3.0b2-3.1 Thunderbird/3.0b2
MIME-Version: 1.0
To: mingo@redhat.com
CC: x86@kernel.org, linux-kernel@vger.kernel.org,
       Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 1/3] x86_32: apic/es7000_32, fix section mismatch
References: <1235989134-29146-1-git-send-email-jirislaby@gmail.com>
In-Reply-To: <1235989134-29146-1-git-send-email-jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2.3.2009 11:18, Jiri Slaby wrote:
> Remove __init section placement for some functions, so that we don't
> get section mismatch warnings.

Oops, just ignore these. DEBUG_SECTION_MISMATCH has some false negatives.
