Return-Path: <linux-kernel-owner+w=401wt.eu-S1752757AbZGPGtv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752757AbZGPGtv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jul 2009 02:49:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752457AbZGPGtv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 16 Jul 2009 02:49:51 -0400
Received: from smtp.nokia.com ([192.100.122.230]:18976 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751932AbZGPGtu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jul 2009 02:49:50 -0400
Date: Thu, 16 Jul 2009 09:48:02 +0300
From: Felipe Balbi <felipe.balbi@nokia.com>
To: ext Jeff Garzik <jeff@garzik.org>
Cc: Junio C Hamano <gitster@pobox.com>,
       "git@vger.kernel.org" <git@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: [ANNOUNCE] GIT 1.6.4.rc1
Message-ID: <20090716064802.GG5256@nokia.com>
Reply-To: felipe.balbi@nokia.com
References: <7vmy75bg2f.fsf@alter.siamese.dyndns.org>
 <4A5EA598.5050801@garzik.org>
 <7v3a8xb0lz.fsf@alter.siamese.dyndns.org>
 <4A5ECC09.3010405@garzik.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4A5ECC09.3010405@garzik.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-OriginalArrivalTime: 16 Jul 2009 06:48:05.0857 (UTC) FILETIME=[5F538510:01CA05E1]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 16, 2009 at 08:43:21AM +0200, ext Jeff Garzik wrote:
> Junio C Hamano wrote:
> > Jeff Garzik <jeff@garzik.org> writes:
> > 
> >> Is there some sort of guide to the new best practices for handling
> >> trees such as git.kernel.org, where one pushes into "foo.git"
> >> directly, and there is no checked-out source code at all?
> > 
> > I think old repositories will be helped if you add
> > 
> > 	[core]
> >         	bare
> > 
> > to their foo.git/config files.
> 
> Thanks.  What about cloning new repositories?  Real world example:
> 
> Local workstation has /spare/repo/cld/.git repository, with checked-out 
> working tree.
> 
> I want to publish this tree to the world via a *.kernel.org-like system, 
> so my task is to
> 
> 	scp -r /spare/repo/cld/.git remote.example.com:/pub/scm/cld.git
> 
> but if I do this with scp, then future pushes to 
> remote.example.com:/pub/scm/cld.git emit the warning about updating the 
> currently checked-out branch -- even though there are no checked-out 
> files.  The checked-out files were not copied in the scp.

how about you create the bare repository on the kernel.org-like server
and then push cld to it ?

-- 
balbi
