Return-Path: <linux-kernel-owner+w=401wt.eu-S1758149AbZBPNV2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758149AbZBPNV2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Feb 2009 08:21:28 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755929AbZBPNVT
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 16 Feb 2009 08:21:19 -0500
Received: from ti-out-0910.google.com ([209.85.142.191]:63688 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756061AbZBPNVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Feb 2009 08:21:18 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=qZSzrW6MAdDLbD4sDT6Hv/UJXd1cLIsHK4mJLbKtCNmZQ0z6EgjmplYEuTJjRhhp2F
         JGuUCJ/i3KlJ75ImF8GZm+DKkgswWCiRA0kv93n77DdK0eCrUYusvAipgaafjq8+CM3x
         6OJnmZwIy1fYCrGodngxtXvozpaNVX6YTES8o=
Date: Mon, 16 Feb 2009 21:21:18 +0800
From: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: =?utf-8?Q?Am=C3=A9rico?= Wang <xiyou.wangcong@gmail.com>,
       Luca Bigliardi <shammash@artha.org>, trivial@kernel.org,
       linux-kernel@vger.kernel.org, jdike@addtoit.com,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] Fix vde network backend in user mode linux
Message-ID: <20090216132118.GD23665@hack.private>
References: <20090202172822.GA2801@pintsize> <alpine.LNX.1.10.0902161334250.18110@jikos.suse.cz> <20090216124939.GC23665@hack.private> <alpine.LNX.1.10.0902161350350.18110@jikos.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.1.10.0902161350350.18110@jikos.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 16, 2009 at 01:51:35PM +0100, Jiri Kosina wrote:
>On Mon, 16 Feb 2009, Américo Wang wrote:
>
>> >[ doesn't seem to be picked up by anyone into current -next nor -mmotm, 
>> >  but isn't appropriate for trivial; adding akpm to cc ]
>> >> * Replace kmalloc() with uml_kmalloc()
>> >>   (fix build failure)
>> Weird... I sent a patch for this several months ago! I thought Jeff had 
>> already taken it... No?
>
>I am not sure whether this has been fixed in another way, but current 
>linux-next still has
>
>	void vde_init_libstuff(struct vde_data *vpri, struct vde_init *init)
>	{
>	        struct vde_open_args *args;
>	
>	        vpri->args = kmalloc(sizeof(struct vde_open_args), UM_GFP_KERNEL);
>
>so the patch hasn't been at least applied in the form it has been 
>submitted.

Hmmm, no, I just checked, but more than half a year ago, we already
did this: http://lkml.org/lkml/2008/7/23/142

It looks like Jeff is too busy to maintain UML patches recently...

Andrew, could you please take UML patches for us? Recently I also
saw some uml patches but no one took them (at least I don't know).

If Andrew can't do this, I would like to take those patches to send
to Linus, if others don't have objections. Andrew?

-- 
"Against stupidity, the gods themselves, contend in vain."

