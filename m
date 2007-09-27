Return-Path: <linux-kernel-owner+w=401wt.eu-S1755164AbXI0MlN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755164AbXI0MlN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2007 08:41:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755668AbXI0Mkw
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 27 Sep 2007 08:40:52 -0400
Received: from nic.NetDirect.CA ([216.16.235.2]:39800 "EHLO
	rubicon.netdirect.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755499AbXI0Mkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2007 08:40:51 -0400
X-Originating-Ip: 72.143.66.27
Date: Thu, 27 Sep 2007 08:38:54 -0400 (EDT)
From: "Robert P. J. Day" <rpjday@mindspring.com>
X-X-Sender: rpjday@localhost.localdomain
To: Cedric Le Goater <clg@fr.ibm.com>
cc: Pavel Emelyanov <xemul@openvz.org>, Andrew Morton <akpm@osdl.org>,
       Serge Hallyn <serue@us.ibm.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Linux Containers <containers@lists.osdl.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/5] Move the user namespace under the option
In-Reply-To: <46FBA2A4.2040909@fr.ibm.com>
Message-ID: <Pine.LNX.4.64.0709270837220.5275@localhost.localdomain>
References: <46FA7D4D.8040808@openvz.org> <46FA8087.6060307@openvz.org>
 <46FBA2A4.2040909@fr.ibm.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Net-Direct-Inc-MailScanner-Information: Please contact the ISP for more information
X-Net-Direct-Inc-MailScanner: Found to be clean
X-Net-Direct-Inc-MailScanner-SpamCheck: not spam, SpamAssassin (not cached,
	score=-16.8, required 5, autolearn=not spam, ALL_TRUSTED -1.80,
	BAYES_00 -15.00, INIT_RECVD_OUR_AUTH -20.00,
	RCVD_IN_SORBS_DUL 20.00)
X-Net-Direct-Inc-MailScanner-From: rpjday@mindspring.com
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2007, Cedric Le Goater wrote:

> > diff --git a/include/linux/user_namespace.h b/include/linux/user_namespace.h
> > index b5f41d4..dda160c 100644
> > --- a/include/linux/user_namespace.h
> > +++ b/include/linux/user_namespace.h
> > @@ -17,7 +17,7 @@ struct user_namespace {
> >
> >  extern struct user_namespace init_user_ns;
> >
> > -#ifdef CONFIG_USER_NS
> > +#ifdef CONFIG_NAMESPACES_EXPERIMENTAL

is it really a good precedent to introduce Kconfig variables that
literally include the word "EXPERIMENTAL"?

rday
-- 
========================================================================
Robert P. J. Day
Linux Consulting, Training and Annoying Kernel Pedantry
Waterloo, Ontario, CANADA

http://crashcourse.ca
========================================================================
