Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751931Ab0BNQl2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Feb 2010 11:41:28 -0500
Received: from mail-ew0-f228.google.com ([209.85.219.228]:58178 "EHLO
	mail-ew0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab0BNQl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Feb 2010 11:41:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=J+QW1YYMmInY9vpZpbWBxuzRG69W4cEEpFtJkGewdAsD/55Bb2639gYnPM4hzXwuP6
         8jTC98CGHfdP4FnX11FMT/AGcoCwRWE1pvzHEBk4rgQgFscUMH0563H/eHJuvyVwtWuQ
         u3OCnfOM4QSD8RMPNyGZ6kITTKfln8pQzHxcY=
Message-ID: <4B78296A.10002@gmail.com>
Date: Sun, 14 Feb 2010 17:48:42 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Roel Kluin <roel.kluin@gmail.com>
CC: paul@pwsan.com, Andrew Morton <akpm@linux-foundation.org>,
       linux-omap@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] OMAP: Dereference of NULL autodep in _autodep_lookup()
References: <4B781E05.9040502@gmail.com>
In-Reply-To: <4B781E05.9040502@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 14-02-10 17:00, Roel Kluin schreef:
> Don't dereference autodep when it's NULL. In _autodep_lookup() an
> ERR_PTR(-ENOENT) is assigned to autodep->pwrdm.ptr if pwrdm_lookup() fails.

I am not sure whether my patch was right, if indeed a dereference, then it
appears to also occur in _clkdm_add_autodeps() and _clkdm_del_autodeps().

Roel
