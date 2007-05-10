Return-Path: <linux-kernel-owner+w=401wt.eu-S1758869AbXEJTL1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758869AbXEJTL1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2007 15:11:27 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756240AbXEJTLU
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 May 2007 15:11:20 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:33403 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756184AbXEJTLU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2007 15:11:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:date:from:to:cc:subject:message-id:references:mime-version:content-type:content-disposition:in-reply-to:user-agent;
        b=EhHNbqnSDmVEtAkvGA1q8JkrkGi0eaAoXrE4VQsfTxKmXd+H7hHdnwEmlNIlph+WGsHfsQCQp2kN5ER0gSUGe7rDClgLmHvwNGYxV5BrPBw/d4nYF/gScDD2KgAeVwFpAdfU2G2C9ZF9jWDryFZUuPhB0oSbouw6pO/WUQgioi8=
Date: Thu, 10 May 2007 23:11:44 +0400
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Martin Knoblauch <spamtrap@knobisoft.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ssh no longer working after upgrading from 2.6.19.2 -> 2.6.21.1
Message-ID: <20070510191144.GB5709@martell.zuzino.mipt.ru>
References: <962825.15262.qm@web32608.mail.mud.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <962825.15262.qm@web32608.mail.mud.yahoo.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2007 at 11:02:39AM -0700, Martin Knoblauch wrote:
> > after upgrading a system from 2.6.19.2 to 2.6.21.1 access to that
> > system via "ssh" has stopped. The ssh-clients accessing the 2.6.21.1
> > box just hang and cannot even be killed.
> >
> > The upgraded system has a RHEL4U3 user-space. 2.6.21.1 configuration
> > was derived from 2.6.19.2. Both configs are attached.
> >
> > Any ideas would be highly welcome. Please CC me, as I am not
> > subscribed.
>
>  apparently I was not careful in selecting the default answers to make
> oldconfig. After some experimenting I have now a working 2.6.21.1
> config. Not sure (and not enough time) to find out which parameter
> caused the problems with ssh. The new config is attached.

CONFIG_SYSFS_DEPRECATED=y

	Alexey, who lost half of today fighting exactly same symptoms

sigh...

