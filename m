Return-Path: <linux-kernel-owner+w=401wt.eu-S1763202AbZLPUHT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763202AbZLPUHT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Dec 2009 15:07:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763164AbZLPUHN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 16 Dec 2009 15:07:13 -0500
Received: from outbound-mail-101.bluehost.com ([69.89.22.11]:37054 "HELO
	outbound-mail-101.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1763192AbZLPUHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Dec 2009 15:07:11 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=Llc0OvRYMtN3IXIEoXvoFqyUfJLfWibdjxvpze3Em2OgJg+AM0tVoXFfW4ds/ildvnJhH9d4nSYAB6FzAH0HgnKdZQQ3VL5e7C7C4nWMxQAwTCUpLlfe5jlOq2sDmPIL;
Date: Wed, 16 Dec 2009 12:06:43 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Robert Hancock <hancockrwd@gmail.com>,
       Tvrtko Ursulin <tvrtko@ursulin.net>,
       Tvrtko Ursulin <tvrtko.ursulin@sophos.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86/pci: don't check mmconf again if it is from MSR
 with amd faml0h
Message-ID: <20091216120643.50070952@jbarnes-piketon>
In-Reply-To: <4B26F8BD.5070501@kernel.org>
References: <200912130807.44905.tvrtko@ursulin.net>
	<200912141934.10628.tvrtko@ursulin.net>
	<4B26965C.6020203@kernel.org>
	<200912142016.53160.tvrtko@ursulin.net>
	<4B269F92.1050909@kernel.org>
	<4B26E4C7.8040100@gmail.com>
	<4B26F8BD.5070501@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Dec 2009 18:47:25 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> for AMD Fam10h, it we read mmconf from MSR early, we should just
> trust it because we check it and correct it already.
> 
> so skip the reject check there.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>
> 

Why is mmconfig getting rejected on this platform?  Seems like that
should be fixed instead, rather than adding a whitelist of one.

-- 
Jesse Barnes, Intel Open Source Technology Center
