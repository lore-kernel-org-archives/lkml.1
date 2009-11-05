Return-Path: <linux-kernel-owner+w=401wt.eu-S1754665AbZKELbH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665AbZKELbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Nov 2009 06:31:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753936AbZKELbF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 5 Nov 2009 06:31:05 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:63035 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753858AbZKELbE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Nov 2009 06:31:04 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Michael S. Tsirkin" <mst@redhat.com>
Subject: Re: [PATCHv6 1/3] tun: export underlying socket
Date: Thu, 5 Nov 2009 12:30:43 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.31-14-generic; KDE/4.3.2; x86_64; ; )
Cc: virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
       kvm@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       linux-mm@kvack.org, akpm@linux-foundation.org, hpa@zytor.com,
       gregory.haskins@gmail.com, Rusty Russell <rusty@rustcorp.com.au>,
       s.hetze@linux-ag.com
References: <cover.1257193660.git.mst@redhat.com> <200911041909.06054.arnd@arndb.de> <20091104190523.GA772@redhat.com>
In-Reply-To: <20091104190523.GA772@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <200911051230.43272.arnd@arndb.de>
X-Provags-ID: V01U2FsdGVkX1/pz6eud0/A0bku24muw1CK5NUxghP0VGk/7rN
 5p7oYcCGK8JL6sIzaT3OssP1OC5d8NaxI4fv3LlOyhDuiIgzGg
 h8pjzuEMO9xFHG5N3Rbnw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 04 November 2009, Michael S. Tsirkin wrote:
> > 
> > Michael, you didn't reply on this comment and the code is still there in v8.
> > Do you actually need this? What for?
> > 
> >       Arnd <><
> 
> Sorry, missed the question. If you look closely it is not exported for
> !__KERNEL__ at all.  The stub is for when CONFIG_TUN is undefined.
> Maybe I'll add a comment near #else, even though this is a bit strange
> since the #if is just 2 lines above it.

Ah right, I'm just blind.

Don't bother changing it then, the code looks good as it is.

	Arnd <><
