Return-Path: <linux-kernel-owner+w=401wt.eu-S1753374AbZGAH0m@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753374AbZGAH0m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jul 2009 03:26:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752722AbZGAH0f
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 1 Jul 2009 03:26:35 -0400
Received: from wa-out-1112.google.com ([209.85.146.181]:45301 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095AbZGAH0e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jul 2009 03:26:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=cp46QG9wUIb1ApHyMqS1KGc8UWDkeaHWBaXi1S9mxUq/nu/FGFWR4uGDTjCv6TiRRr
         TK+O1+R4rOZ5oild0/5wlYHwZgQgNh4qCQNrxVv2xVvZCOoCxwdVOgK+/nSwO07y5rvf
         S/Oc+Cdkitoq/WdJBisBch+e1ze4yjFgLBUCE=
Date: Wed, 1 Jul 2009 15:28:44 +0800
From: Amerigo Wang <xiyou.wangcong@gmail.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: sam@ravnborg.org, Rusty Russell <rusty@rustcorp.com.au>,
       tony.luck@intel.com, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       Paul Mackerras <paulus@samba.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] also discard .*init sections after module
	initialization
Message-ID: <20090701072844.GG6076@cr0.nay.redhat.com>
References: <4A4A19C60200007800008353@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A4A19C60200007800008353@vpn.id2.novell.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 30, 2009 at 12:57:26PM +0100, Jan Beulich wrote:
>Just like .init, these sections are supposed to be unneeded after init,
>and modpost warns about improper section references anyway. Likewise
>for .*exit which, other than .exit, aren't needed for the module unload
>path.
>

<snip>

> 
>+bool is_init_section_name(const char *name)
>+{


According to your description, this function name
looks confusing... at least for me.
