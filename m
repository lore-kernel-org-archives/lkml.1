Return-Path: <linux-kernel-owner+w=401wt.eu-S1759405AbYGaWPN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759405AbYGaWPN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jul 2008 18:15:13 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760267AbYGaWOh
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jul 2008 18:14:37 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:57541 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760260AbYGaWOe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jul 2008 18:14:34 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: James Morris <jmorris@namei.org>
Subject: 2.6.27-rc1: strange fstab issue (Re: 2.6.27-rc1 + selinux new options = no httpd)
Date: Fri, 1 Aug 2008 00:17:27 +0200
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Eric Paris <eparis@redhat.com>, Stephen Smalley <sds@tycho.nsa.gov>
References: <200807302254.26036.gene.heskett@gmail.com> <200807310909.27619.gene.heskett@gmail.com> <Xine.LNX.4.64.0808010559290.30244@us.intercode.com.au>
In-Reply-To: <Xine.LNX.4.64.0808010559290.30244@us.intercode.com.au>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808010017.28125.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, 31 of July 2008, James Morris wrote:
> On Thu, 31 Jul 2008, Gene Heskett wrote:
> 
> > >Which new options?
> > 
> > Make xconfig-->security options:
> > 
> > XFRM Networking security hooks
> > 
> >  and several others just below it.  Unforch, I can't copy/paste the screen.  
> 
> I can't really imagine what that is (although if you enable the secmark 
> controls under the main SELinux menu, which are disabled by default, 
> there could be problems).

On a possibly related note, I've been observing a strange issue on one of
my test boxes with OpenSUSE 10.3 recently.   Namely, the fsck complains
that there's no passno value in the fstab, although it obviously is present.

Strangely enough, if the kernel is compiled with CONFIG_SECURITY_SELINUX unset,
the fsck doesn't complain about the missing passno field any more.

Thanks,
Rafael
