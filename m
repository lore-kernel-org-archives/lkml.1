Return-Path: <linux-kernel-owner+w=401wt.eu-S1756267AbYJLUjA@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756267AbYJLUjA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2008 16:39:00 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753762AbYJLUis
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 12 Oct 2008 16:38:48 -0400
Received: from ug-out-1314.google.com ([66.249.92.170]:12151 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753666AbYJLUir (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2008 16:38:47 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=wsYP1NlUPr4aTl4VkZZbYF8kRkHP3bJxl7gV0RjUM20E4gK3112jEJEOvy+qbkqNLb
         JEBnTmagGjJPJe7hhAF6j6FRCpTnWdlcVxo5LCKwqvj2I1ZG7hmlA90KZZ7IPfsL5rBN
         mBteuIUY83JnbrZGkZNLSYm2JIxoYaV0h2GWU=
Message-ID: <524f69650810121338y4bd00ec2pd213f6d933209cbf@mail.gmail.com>
Date: Sun, 12 Oct 2008 15:38:46 -0500
From: "Steve French" <smfrench@gmail.com>
To: "Jeff Layton" <jlayton@redhat.com>
Subject: Re: [linux-cifs-client] Fwd: [PATCH] Fix CIFS compilation with CONFIG_KEYS unset
Cc: rjw@sisk.pl,
       "linux-cifs-client@lists.samba.org" 
	<linux-cifs-client@lists.samba.org>,
       netdev@vger.kernel.org, cooldavid@cooldavid.org,
       "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
       "David Miller" <davem@davemloft.net>,
       LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <20081012161634.5e410c24@tleilax.poochiereds.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <200810121315.37203.rjw@sisk.pl>
	 <524f69650810120640v41778375wf0a7662e773da26f@mail.gmail.com>
	 <20081012095903.33427ee8@tleilax.poochiereds.net>
	 <524f69650810120953t2ec8100cpdddc3ddfce0406d9@mail.gmail.com>
	 <524f69650810120957t1a81f23lf3fd75fee78e72c3@mail.gmail.com>
	 <20081012161634.5e410c24@tleilax.poochiereds.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2008 at 3:16 PM, Jeff Layton <jlayton@redhat.com> wrote:
> It's your call, but if we're going to carry a temporary patch, then I'd
> prefer to just carry the one that adds the empty key_revoke definition.
> I don't think there's much benefit to changing the cifs code for this,
> but I don't feel very strongly about it either way...
> --
> Jeff Layton <jlayton@redhat.com>

There are probably various CIFS_UPCALL related ifdefs that could be
merged/shrunk - let's do this as a set later.


-- 
Thanks,

Steve
