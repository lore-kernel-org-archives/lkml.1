Return-Path: <linux-kernel-owner+w=401wt.eu-S1755023AbYJEB7q@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755023AbYJEB7q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Oct 2008 21:59:46 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753187AbYJEB7j
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Oct 2008 21:59:39 -0400
Received: from rv-out-0506.google.com ([209.85.198.224]:44804 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752915AbYJEB7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Oct 2008 21:59:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=Y8d3zrjWuhR2J+5Smnb7fqAd0UN+WJAeTd16eDN8fxjw3BTbAc1ifXK/5QaYzTjVrT
         l2LPNQ2D3NOWn5jTwb8IftTBJRZOAh0NhHUcHS6gUT1hdHbIOZcqex00/tXQYXPn/w0n
         p3O+Qw9bNot3bs2WDg2LC76cddP9D9Iz5iXTY=
Message-ID: <86802c440810041859s3695ff66v1833193f737551c8@mail.gmail.com>
Date: Sat, 4 Oct 2008 18:59:37 -0700
From: "Yinghai Lu" <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH 2/3] x86: mtrr_cleanup: first 1M should be coverred in var mtrrs
Cc: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
       "Andrew Morton" <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <48E81DED.7050902@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <1223157033-30217-1-git-send-email-yhlu.kernel@gmail.com>
	 <1223157033-30217-2-git-send-email-yhlu.kernel@gmail.com>
	 <48E80E60.8080106@zytor.com>
	 <86802c440810041849g421ff524pf987f6c872e1d12a@mail.gmail.com>
	 <48E81DED.7050902@zytor.com>
X-Google-Sender-Auth: 2a8289fbe212c662
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 4, 2008 at 6:52 PM, H. Peter Anvin <hpa@zytor.com> wrote:

> There are some systems which, apparently, don't have RAM there.  Don't ask
> me how or why.

very old system or
very new system only have super big cache?

YH
