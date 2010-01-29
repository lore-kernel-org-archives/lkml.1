Return-Path: <linux-kernel-owner+w=401wt.eu-S1754638Ab0A2WKk@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754638Ab0A2WKk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jan 2010 17:10:40 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753607Ab0A2WKj
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 29 Jan 2010 17:10:39 -0500
Received: from mail-bw0-f227.google.com ([209.85.218.227]:51373 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752303Ab0A2WKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jan 2010 17:10:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LlGHvX+n3tlxD7En/IACvgiE1jX6q4QYC7dj/6QQ8MNM9erB1dYuKUYCoU56DWPQ5c
         dFKYRsuzz7W5yVJAzqqVKq455IpawywuxxyI5iaYsqEd1+e0IwXpg5I+jYZccOUxg+si
         P8NLJNIAyl2+fs1u38HrhUPfiUslgc28zaRVU=
Subject: Re: [PATCH v3] port ricoh_mmc to pci quirk
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Philip Langdale <philipl@overt.org>
Cc: Wolfram Sang <w.sang@pengutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       Pierre Ossman <pierre@ossman.eu>,
       linux-kernel <linux-kernel@vger.kernel.org>, linux-mmc@vger.kernel.org
In-Reply-To: <20100129080639.3b484a59@fido2.homeip.net>
References: <20091125085324.1ef9ae1f@fido2.homeip.net>
	 <20091125113501.1f4d42b9.akpm@linux-foundation.org>
	 <1259192401.15916.48.camel@maxim-laptop>
	 <20091125173019.74d0ddb9@fido2.homeip.net>
	 <1259279520.3991.5.camel@maxim-laptop>
	 <1259279584.3991.6.camel@maxim-laptop>
	 <20091126235551.2db699e3@fido2.homeip.net>
	 <1262964284.12577.27.camel@maxim-laptop>
	 <20100108074001.5df6c997@fido2.homeip.net>
	 <20100112154350.8fa96829.akpm@linux-foundation.org>
	 <20100113064657.GB10955@pengutronix.de>
	 <1264772255.4620.3.camel@maxim-laptop>
	 <20100129080639.3b484a59@fido2.homeip.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 30 Jan 2010 00:10:33 +0200
Message-ID: <1264803033.7095.4.camel@maxim-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-01-29 at 08:06 -0800, Philip Langdale wrote: 
> On Fri, 29 Jan 2010 15:37:35 +0200
> Maxim Levitsky <maximlevitsky@gmail.com> wrote:
> 
> > Here, updated patch with your comments addressed.
> > This is also tested with real MMC card.
> 
> Actual code gets my thumbs up.
> 
> > This adds some > 80 chars lines, but I hope that is ok.
> 
> It's against the coding style and as far as I can see, the only
> lines that are > 80 are the dev_notice and DECLARE_FIXUP lines - both
> of which can be trivially split across multiple lines, so please just
> do that.
Well, I have nothing against this, but, even Linus himself stated that
he dislikes broken printk lines.

I also noticed that some DECLARE_FIXUP in this file are longer that 80,
and since breaking this doesn't add any value, I thought that is ok.
Remember that main purpose of 80 char limit is to make code simpler.

However, I don't really care if you insist.

Best regards,
Maxim Levitsky

