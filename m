Return-Path: <linux-kernel-owner+w=401wt.eu-S1752310AbYJRUIb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752310AbYJRUIb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Oct 2008 16:08:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751034AbYJRUIW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 18 Oct 2008 16:08:22 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:40055 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750966AbYJRUIV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Oct 2008 16:08:21 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Renato S. Yamane" <yamane@diamondcut.com.br>
Subject: Re: [Bug 10797] Battery is drained after poweroff
Date: Sat, 18 Oct 2008 22:12:33 +0200
User-Agent: KMail/1.9.9
Cc: "Pavel Machek" <pavel@suse.cz>, linux-kernel@vger.kernel.org,
       power-management_other@kernel-bugs.osdl.org
References: <4199.200.180.173.111.1224358421.mandic:mail - neo@webmail.mandic.com.br>
In-Reply-To: <4199.200.180.173.111.1224358421.mandic:mail - neo@webmail.mandic.com.br>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200810182212.34290.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, 18 of October 2008, Renato S. Yamane wrote:
> Rafael J. Wysocki wrote:
> > It follows from your reports that the problem is present in 2.6.22, although
> > it wasn't present in 2.6.21.  If that's correct, you can do the following:
> > 1) Clone the Linus' -git repository (if you have a copy already, you can use
> > it)
> > 2) Go to the directory containing your copy of the Linus' repo and do
> > 	# git bisect start
> > 	# git bisect good v2.6.21
> > 	# git bisect bad v2.6.22
> > 3) Wait for git to select a commit to test, build the kernel and test it.
> 
> $ git bisect good v2.6.22
> $ git bisect bad v2.6.23
> Bisecting: *3554* revisions left to test after this
> 
> This means that I need compile kernel *3554* times?

No, you'll need to compile it approximately log_2(3554) times which is not
that bad. :-)

Thanks,
Rafael
