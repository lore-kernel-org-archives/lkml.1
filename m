Return-Path: <linux-kernel-owner+w=401wt.eu-S1755114AbZEYKyG@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114AbZEYKyG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 06:54:06 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753297AbZEYKxx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 06:53:53 -0400
Received: from mail-fx0-f168.google.com ([209.85.220.168]:36598 "EHLO
	mail-fx0-f168.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751649AbZEYKxx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 06:53:53 -0400
MIME-Version: 1.0
In-Reply-To: <m13aataaa6.fsf@fess.ebiederm.org>
References: <m1bppofm9k.fsf@fess.ebiederm.org> <1243109591-21611-5-git-send-email-ebiederm@xmission.com> 
	<ac3eb2510905231427x62efaecfod2b11472fcdbcc21@mail.gmail.com> 
	<1243169978.3502.7.camel@poy> <m1bppid1pw.fsf@fess.ebiederm.org> 
	<1243178448.4035.12.camel@poy> <m1iqjpaap1.fsf@fess.ebiederm.org> 
	<m13aataaa6.fsf@fess.ebiederm.org>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Mon, 25 May 2009 12:51:57 +0200
Message-ID: <ac3eb2510905250351x473fd81fuc183d6f355d5b18a@mail.gmail.com>
Subject: Re: [PATCH 25/20] sysfs: Only support removing emtpy sysfs 
	directories.
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Cornelia Huck <cornelia.huck@de.ibm.com>,
       linux-fsdevel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@aristanetworks.com>,
       stern <stern@rowland.harvard.edu>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 25, 2009 at 09:53, Eric W. Biederman <ebiederm@xmission.com> wrote:
> ebiederm@xmission.com (Eric W. Biederman) writes:

> Currently I expect that those attributes that are not deleted may
> actually be bugs as well.  If a driver manually adds sysfs files after
> device_create/device_register the uevent will have already been sent
> and you can not safely use those attributes in when processing a hotplug
> event.

That's true, and would be good to fix. I guess we need to come up with
a way of maintaining binary attributes in the same way as "default"
attributes. Today they need to be created manually.

Maybe we can get your patch series in, with the version that removes
the files, but warns on existing directories, and work on fixing the
users, and possible remove the deletion of files when we fixed all the
current users?

Thanks,
Kay
