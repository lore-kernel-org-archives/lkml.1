Return-Path: <linux-kernel-owner+w=401wt.eu-S1754000AbYKATYx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754000AbYKATYx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2008 15:24:53 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752589AbYKATYp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 1 Nov 2008 15:24:45 -0400
Received: from nf-out-0910.google.com ([64.233.182.188]:43823 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752615AbYKATYo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2008 15:24:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=A4+k+OYnlF5gsmR2Tipk/oD2A/7GUiGT21PCuiyCUix2IwarhdQHD28IaIE0OZUVoj
         lWaeultjTqfTs8ZqzgYyDr5lZX9h1NoerEeCNpV6GwpjqKeXahvQWfiV75vRjP0XddYR
         Q1LqJlp6S73gbPW6pu8Qz8fn+TcKGmZKjYTak=
Date: Sat, 1 Nov 2008 22:27:57 +0300
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Al Viro <viro@ftp.linux.org.uk>, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jgarzik@pobox.com
Subject: Re: [PATCH] el3_common_init() should be __devinit, not __init
Message-ID: <20081101192757.GA7622@x200.localdomain>
References: <E1KwL59-0000Ug-F1@ZenIV.linux.org.uk> <20081101191250.GA7588@x200.localdomain> <20081101191614.GA28946@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081101191614.GA28946@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 01, 2008 at 07:16:14PM +0000, Al Viro wrote:
> On Sat, Nov 01, 2008 at 10:12:50PM +0300, Alexey Dobriyan wrote:
> > On Sat, Nov 01, 2008 at 06:20:19PM +0000, Al Viro wrote:
> > > -static int __init el3_common_init(struct net_device *dev)
> > > +static int __devinit el3_common_init(struct net_device *dev)
> > 
> > Al, here is much better patch:
> 
> [essentially kill devinit/cpuinit]
> 
> What the hell makes it better?

Wasting efforts for too little gain?

More or less every distro enables HOTPLUG and HOTPLUG_CPU.
