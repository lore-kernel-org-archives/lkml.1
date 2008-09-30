Return-Path: <linux-kernel-owner+w=401wt.eu-S1753566AbYI3QGR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753566AbYI3QGR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2008 12:06:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752999AbYI3QGE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 30 Sep 2008 12:06:04 -0400
Received: from rv-out-0506.google.com ([209.85.198.230]:62929 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752927AbYI3QGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2008 12:06:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=P3zUwEuIjTQp19PO7/47AoJEvGSZHrUMxp8bMG70b6y2YOwGtwWv+uUzkWdeRK2JHa
         0JtzXPKuEZLQOf780KE3bQhbc9PQxRfitnmxuDCWwrXjtn14OjMTCF/Vwu9YandX7sMS
         YVD+gtGbAACxYC5zQIokCl5tUAYuE9xmThCcg=
Message-ID: <86802c440809300906i2ef08065o1f9cf9999e39cc2f@mail.gmail.com>
Date: Tue, 30 Sep 2008 09:06:01 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "Ingo Molnar" <mingo@elte.hu>
Subject: Re: [PATCH 1/2] x86: mtrr_cleanup prepare to make gran_size to less 1M
Cc: "H. Peter Anvin" <hpa@zytor.com>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080930081141.GA29840@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1222739652-17169-1-git-send-email-yhlu.kernel@gmail.com>
	 <48E1A5E8.3030304@zytor.com> <20080930074552.GA19366@elte.hu>
	 <20080930081141.GA29840@elte.hu>
X-Google-Sender-Auth: 014e223fc7327de6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 30, 2008 at 1:11 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Ingo Molnar <mingo@elte.hu> wrote:
>
>> * H. Peter Anvin <hpa@zytor.com> wrote:
>>
>> > Applied series to tip:x86/mtrr, thanks!
>>
>> tested them and pushed it out into tip/master.
>
> btw., now that we've got wide enough exposure (a kernel release), could
> we please flip around the default of CONFIG_MTRR_SANITIZER and make it
> default-y? This feature should only produce a worse result if there's a
> bug in that code, right?

it will compare the exact mem range between the updated and original,
so it should be safe to set it to default-y.

YH
