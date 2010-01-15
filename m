Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758029Ab0AOTmO (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 15 Jan 2010 14:42:14 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757973Ab0AOTmJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 15 Jan 2010 14:42:09 -0500
Received: from outbound-mail-01.bluehost.com ([69.89.21.11]:45840 "HELO
	outbound-mail-01.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1757744Ab0AOTmI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jan 2010 14:42:08 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=ZmEOCcM75iblgBMAoqEV7ei8T9ZLIOvPMAWcF2nBYcS1etnc0hHOLa1Fx3xaBRUK7NaorWdVR5V+BMXjTlGoEOLYZzrUQcfQc/Y8P7WmJReaVMtjBK4f4wBUfz1B/YIb;
Date: Fri, 15 Jan 2010 11:42:05 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>
Subject: Re: [PATCH 7/7] x86/pci: don't check mmconf again if it is from MSR
 with amd faml0h
Message-ID: <20100115114205.247c5dd7@jbarnes-piketon>
In-Reply-To: <4B2BE196.2000404@kernel.org>
References: <4B2BE063.4040704@kernel.org>
	<4B2BE196.2000404@kernel.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 18 Dec 2009 12:09:58 -0800
Yinghai Lu <yinghai@kernel.org> wrote:

> 
> for AMD Fam10h, it we read mmconf from MSR early, we should just
> trust it because we check it and correct it already.
> 
> so skip the reject check there.
> 
> Signed-off-by: Yinghai Lu <yinghai@kernel.org>

My previous question wasn't answered.  Either reject_broken should be a
no-op on this platform, or it's getting things wrong and should be
fixed.  Adding a whitelist here seems like the wrong thing to do...

-- 
Jesse Barnes, Intel Open Source Technology Center
