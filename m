Return-Path: <linux-kernel-owner+w=401wt.eu-S1755976AbZGUU7f@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755976AbZGUU7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jul 2009 16:59:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755356AbZGUU7e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 21 Jul 2009 16:59:34 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:53440 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752398AbZGUU7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jul 2009 16:59:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:x-enigmail-version:content-type
         :content-transfer-encoding;
        b=o4DrjuRPwzQeTnTCM394bAdtBY1mTBLny/hwlPLpjH4b0cRJWWQG8DSxzeAMp8+eGL
         aiyRKpVfw5Uz2k+i0lzzrIc0FV0THH4IBZOb+z/Sefb/WJqK0vvgXnP4AXmP/hcOcqcq
         Er6TE2fPKHAbOr7lQp96ncX4fxXKqDH+5ATls=
Message-ID: <4A662C33.7080505@gmail.com>
Date: Tue, 21 Jul 2009 22:59:31 +0200
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1pre) Gecko/20090528 SUSE/3.0b2-11.8 Thunderbird/3.0b3pre
MIME-Version: 1.0
To: Pekka Paalanen <pq@iki.fi>
CC: linux-kernel@vger.kernel.org
Subject: Re: Do cpu-endian MMIO accessors exist?
References: <20090721234243.1928d9e2@daedalus.pq.iki.fi>
In-Reply-To: <20090721234243.1928d9e2@daedalus.pq.iki.fi>
X-Enigmail-Version: 0.96a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2009 10:42 PM, Pekka Paalanen wrote:
> This is for Nouveau, where the hardware is configured to have the
> same endianess as the cpu. Well, it's configured BE for PPC and
> LE otherwise.

But not only ppc is BE.

> Do cpu-endian MMIO accessors exist? What should I use, or do I just
> have to use #ifdef __BIG_ENDIAN?

There is __raw_readl which doesn't switch bytes.
