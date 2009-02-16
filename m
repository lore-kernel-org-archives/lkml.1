Return-Path: <linux-kernel-owner+w=401wt.eu-S1757429AbZBPMvr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757429AbZBPMvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 07:51:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754842AbZBPMvi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 07:51:38 -0500
Received: from cantor2.suse.de ([195.135.220.15]:46457 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754635AbZBPMvi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 07:51:38 -0500
Date: Mon, 16 Feb 2009 13:51:35 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: =?ISO-8859-15?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: Luca Bigliardi <shammash@artha.org>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, jdike@addtoit.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix vde network backend in user mode linux
In-Reply-To: <20090216124939.GC23665@hack.private>
Message-ID: <alpine.LNX.1.10.0902161350350.18110@jikos.suse.cz>
References: <20090202172822.GA2801@pintsize> <alpine.LNX.1.10.0902161334250.18110@jikos.suse.cz> <20090216124939.GC23665@hack.private>
User-Agent: Alpine 1.10 (LNX 962 2008-03-14)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="336216065-1762519444-1234788695=:18110"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--336216065-1762519444-1234788695=:18110
Content-Type: TEXT/PLAIN; charset=ISO-8859-15
Content-Transfer-Encoding: 8BIT

On Mon, 16 Feb 2009, Américo Wang wrote:

> >[ doesn't seem to be picked up by anyone into current -next nor -mmotm, 
> >  but isn't appropriate for trivial; adding akpm to cc ]
> >> * Replace kmalloc() with uml_kmalloc()
> >>   (fix build failure)
> Weird... I sent a patch for this several months ago! I thought Jeff had 
> already taken it... No?

I am not sure whether this has been fixed in another way, but current 
linux-next still has

	void vde_init_libstuff(struct vde_data *vpri, struct vde_init *init)
	{
	        struct vde_open_args *args;
	
	        vpri->args = kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);

so the patch hasn't been at least applied in the form it has been 
submitted.

-- 
Jiri Kosina
SUSE Labs
--336216065-1762519444-1234788695=:18110--
