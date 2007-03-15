Return-Path: <linux-kernel-owner+w=401wt.eu-S933645AbXCOUAm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933645AbXCOUAm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 16:00:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S933679AbXCOUAm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 16:00:42 -0400
Received: from mx1.redhat.com ([66.187.233.31]:52921 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933645AbXCOUAk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 16:00:40 -0400
Date: Thu, 15 Mar 2007 16:00:12 -0400
From: Dave Jones <davej@redhat.com>
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
       "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.21rc suspend to ram regression on Lenovo X60
Message-ID: <20070315200012.GA5574@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jeremy Fitzhardinge <jeremy@goop.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	"Rafael J. Wysocki" <rjw@sisk.pl>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Greg Kroah-Hartman <gregkh@suse.de>
References: <20070313040828.GA17893@redhat.com> <200703131022.54322.rjw@sisk.pl> <20070313132218.GA25910@redhat.com> <m1d53apjvu.fsf@ebiederm.dsl.xmission.com> <20070315181059.GA1644@redhat.com> <45F9A250.7040409@goop.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <45F9A250.7040409@goop.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 15, 2007 at 12:45:20PM -0700, Jeremy Fitzhardinge wrote:
 > Dave Jones wrote:
 > > I just did a build of top of tree, including those commits, and
 > > it's still broken.  Booting with pci=nomsi no longer 'fixes' it
 > > though, which may indicate that the MSI changes were a red herring.
 > > (Or that the subsequent changes have regressed it even more,
 > >  which seems unlikely looking at the changes).
 > >   
 > 
 > I just found the same thing on my X60.  Current top-of-tree with
 > pci=nomsi does not improve things.  When it resumes, the CPU is working
 > (capslock toggles, sysreq-b reboots), but the screen is blank.

Yeah, I noticed the capslock works.  Networking doesn't come back up
though, and it doesn't seem to answer to command that I type blindly.
Even trying to do something like..

pm-suspend ; dmesg >dmesg.out; /sbin/reboot

doesn't seem to execute the commands on resume.

Switching tty's to X with alt-f7 seems to lock it up to the point that
even capslock doesn't work any more.


I'll try and hook up a usb serial cable and see if I'm lucky enough
to get something useful out of it in the absense of a serial port..

	Dave

-- 
http://www.codemonkey.org.uk
