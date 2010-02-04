Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757590Ab0BDSiy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Feb 2010 13:38:54 -0500
Received: from mail-bw0-f219.google.com ([209.85.218.219]:53210 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753611Ab0BDSiw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Feb 2010 13:38:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:subject:from:reply-to:to:cc:in-reply-to:references
         :content-type:date:message-id:mime-version:x-mailer
         :content-transfer-encoding;
        b=kEM/h6rg6WjyRp5nx5XXhozL6FeZbVCS7UGjVTJAHsvAEWi9Y7cayGC2+EtxRb8AqF
         LQryRvI95viLgBcgdjcv6oVE1/xVmAEZZO8d9FqbCnI+A0aV3ZLN2y8D9mwyNSEMXWnV
         bX3qfs1OMI3pyUIfmEoQwqq6Dr8f19CCbxLvk=
Subject: Re: patch net-restore-ip-source-validation.patch added to
 2.6.32-stable tree
From: jamal <hadi@cyberus.ca>
Reply-To: hadi@cyberus.ca
To: Stefan Lippers-Hollmann <s.L-H@gmx.de>
Cc: gregkh@suse.de, linux-kernel@vger.kernel.org, davem@davemloft.net,
       stable@kernel.org
In-Reply-To: <201002041931.40493.s.L-H@gmx.de>
References: <1265060041850@kroah.org> <201002041850.31310.s.L-H@gmx.de>
	 <1265307247.4651.2.camel@bigi>  <201002041931.40493.s.L-H@gmx.de>
Content-Type: text/plain
Date: Thu, 04 Feb 2010 13:38:45 -0500
Message-Id: <1265308725.4651.14.camel@bigi>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-02-04 at 19:31 +0100, Stefan Lippers-Hollmann wrote:
> Hi
> 
> On Thursday 04 February 2010, jamal wrote:

> > ----
> >         NET_IPV4_CONF_ARP_ACCEPT=21,
> >         NET_IPV4_CONF_ARP_NOTIFY=22,
> >         NET_IPV4_CONF_ACCEPT_LOCAL=23,
> >         NET_IPV4_CONF_SRC_VMARK=24,
> >         __NET_IPV4_CONF_MAX
> > ---
> > 
> > I have a feeling you are missing NET_IPV4_CONF_ACCEPT_LOCAL
> 
> Yes, you're 100% right - such a hunk is missing from queue-2.6.32 [1]
> 

Do you mind changing to NET_IPV4_CONF_SRC_VMARK=23 in that patch?
As i mentioned in my other email it is a wild guess - so it likely will
have no effect but worth a try if you have time.

cheers,
jamal



