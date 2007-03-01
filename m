Return-Path: <linux-kernel-owner+w=401wt.eu-S932854AbXCAAwn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932854AbXCAAwn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Feb 2007 19:52:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932853AbXCAAwn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 28 Feb 2007 19:52:43 -0500
Received: from gundega.hpl.hp.com ([192.6.19.190]:62545 "EHLO
	gundega.hpl.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932849AbXCAAwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Feb 2007 19:52:42 -0500
Date: Wed, 28 Feb 2007 16:51:23 -0800
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Greg KH <gregkh@suse.de>, Jarek Poplawski <jarkao2@o2.pl>,
       "David S. Miller" <davem@davemloft.net>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       netdev@vger.kernel.org
Subject: Re: [PATCH 2.6.20] kobject net ifindex + rename
Message-ID: <20070301005123.GA7116@bougret.hpl.hp.com>
Reply-To: jt@hpl.hp.com
References: <20070228012741.GA3988@bougret.hpl.hp.com> <20070228153617.GA5670@suse.de> <20070301002647.GA7045@bougret.hpl.hp.com> <1172709466.11911.7.camel@johannes.berg>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1172709466.11911.7.camel@johannes.berg>
Organisation: HP Labs Palo Alto
Address: HP Labs, 1U-17, 1501 Page Mill road, Palo Alto, CA 94304, USA.
E-mail: jt@hpl.hp.com
User-Agent: Mutt/1.5.9i
From: Jean Tourrilhes <jt@hpl.hp.com>
X-HPL-MailScanner: Found to be clean
X-HPL-MailScanner-From: jt@hpl.hp.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 01, 2007 at 01:37:46AM +0100, Johannes Berg wrote:
> On Wed, 2007-02-28 at 16:26 -0800, Jean Tourrilhes wrote:
> 
> > +	/* This function is only used for network interface.
> > +	 * Some hotplug package track interfaces by their name and
> > +	 * therefore want to know when the name is changed by the user. */
> 
> Right now, that's true, but wireless is going to start using
> device_rename pretty soon as well. Could you rephrase this comment?
> 
> johannes

	I would prefer to fix the comment when this change actually
happens. I prefer comments to refer to the current reality, rather
than past/future situation. When you introduce wireless renaming, you
will need to verify the whole chain anyway, so you might as well fix
the comment while merging wireless renaming.
	Note also that my comment is technically correct. I did not
say 'netdev' but the more generic term 'network interface', and I
believe your wireless interface is a 'network interface', even if it's
not a netdev ;-)
	But if this really bugs you, please feel free to respin my
patch.

	Have fun...

	Jean

