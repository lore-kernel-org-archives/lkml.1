Return-Path: <linux-kernel-owner+w=401wt.eu-S1751306AbXCOSZY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751306AbXCOSZY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2007 14:25:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751316AbXCOSZY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 15 Mar 2007 14:25:24 -0400
Received: from ebiederm.dsl.xmission.com ([166.70.28.69]:57663 "EHLO
	ebiederm.dsl.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751306AbXCOSZV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2007 14:25:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Dave Jones <davej@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: 2.6.21rc suspend to ram regression on Lenovo X60
References: <20070313040828.GA17893@redhat.com>
	<200703131022.54322.rjw@sisk.pl> <20070313132218.GA25910@redhat.com>
	<m1d53apjvu.fsf@ebiederm.dsl.xmission.com>
	<20070315181059.GA1644@redhat.com>
Date: Thu, 15 Mar 2007 12:24:21 -0600
In-Reply-To: <20070315181059.GA1644@redhat.com> (Dave Jones's message of "Thu,
	15 Mar 2007 14:10:59 -0400")
Message-ID: <m1veh2nz56.fsf@ebiederm.dsl.xmission.com>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Dave Jones <davej@redhat.com> writes:

> I just did a build of top of tree, including those commits, and
> it's still broken.  Booting with pci=nomsi no longer 'fixes' it
> though, which may indicate that the MSI changes were a red herring.
> (Or that the subsequent changes have regressed it even more,
>  which seems unlikely looking at the changes).
>
> .. or it could be something else introduced between rc3 (which is
> what my bisect was based on) and todays tree.
>
> sigh. I'll do more bisecting after lunch.

Thanks.

It is good to know that things are worse, even if that isn't good news.

Eric
