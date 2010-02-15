Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754406Ab0BOJUg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Feb 2010 04:20:36 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:56795 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753510Ab0BOJUe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Feb 2010 04:20:34 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCH 2/2] net/macvtap: add vhost suppor
Date: Mon, 15 Feb 2010 10:20:30 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.33-rc5; KDE/4.3.2; x86_64; ; )
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ed Swierk <eswierk@aristanetworks.com>,
       Patrick McHardy <kaber@trash.net>, Sridhar Samudrala <sri@us.ibm.com>,
       qemu-devel@nongnu.org
References: <201002131133.43028.arnd@arndb.de> <201002131135.08477.arnd@arndb.de> <20100214132732.GB31180@redhat.com>
In-Reply-To: <20100214132732.GB31180@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201002151020.30127.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/MrxHm/5cnnxuo8twyLJnbvLyzHxFvjuS15iV
 fChatEDhOEFV3wQL3zI+O7sw81oGYWt7njGb1VBzxTHc0ue7mS
 Szm26+Ax/aIQnMFM/LWAg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 14 February 2010, Michael S. Tsirkin wrote:
> > @@ -473,7 +477,7 @@ static struct socket *get_socket(int fd)
> >       sock = get_raw_socket(fd);
> >       if (!IS_ERR(sock))
> >               return sock;
> > -     sock = get_tun_socket(fd);
> > +     sock = get_tap_socket(fd);
> >       if (!IS_ERR(sock))
> >               return sock;
> >       return ERR_PTR(-ENOTSOCK);
> 
> This will also need a dependency on macvtap in Kconfig.
> See how it's done for tun.

Ok, I'll add that.

Thanks,

	Arnd
