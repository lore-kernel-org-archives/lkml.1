Return-Path: <linux-kernel-owner+w=401wt.eu-S1755764AbYBQLZU@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764AbYBQLZU (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Feb 2008 06:25:20 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753367AbYBQLZI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 17 Feb 2008 06:25:08 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:37405 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753029AbYBQLZH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Feb 2008 06:25:07 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: 2.6.25-rc2-mm1 (build failure)
Date: Sun, 17 Feb 2008 12:23:09 +0100
User-Agent: KMail/1.9.6 (enterprise 20070904.708012)
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       len.brown@intel.com
References: <20080216002522.9c4bd0fb.akpm@linux-foundation.org> <20080216213225.f5f71c35.randy.dunlap@oracle.com>
In-Reply-To: <20080216213225.f5f71c35.randy.dunlap@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200802171223.10466.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, 17 of February 2008, Randy Dunlap wrote:
> On Sat, 16 Feb 2008 00:25:22 -0800 Andrew Morton wrote:
> 
> > 
> > ftp://ftp.kernel.org/pub/linux/kernel/people/akpm/patches/2.6/2.6.25-rc2/2.6.25-rc2-mm1/
> 
> When SMP=n, x86_64 build gets:
> 
> arch/x86/kernel/built-in.o: In function `acpi_save_state_mem':
> (.text+0xfd7f): undefined reference to `setup_trampoline'
> make[1]: *** [.tmp_vmlinux1] Error 1

Please try the patch at http://lkml.org/lkml/2008/2/16/301 .

Thanks,
Rafael

