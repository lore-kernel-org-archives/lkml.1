Return-Path: <linux-kernel-owner+w=401wt.eu-S1753214AbZHFATj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753214AbZHFATj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Aug 2009 20:19:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752740AbZHFATi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 5 Aug 2009 20:19:38 -0400
Received: from mail-fx0-f228.google.com ([209.85.220.228]:36151 "EHLO
	mail-fx0-f228.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752406AbZHFATi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Aug 2009 20:19:38 -0400
MIME-Version: 1.0
In-Reply-To: <20090806000659.GA22754@kroah.com>
References: <20090805171513.GA10443@kroah.com> <9b2b86520908051355o79699e99ke045b635c6b443ad@mail.gmail.com> 
	<20090806000659.GA22754@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Thu, 6 Aug 2009 02:19:23 +0200
Message-ID: <ac3eb2510908051719o61e1d42er750fe837c824bc0@mail.gmail.com>
Subject: Re: [PATCH] Driver Core: devtmpfs - kernel-maintained tmpfs-based 
	/dev
To: Greg KH <greg@kroah.com>
Cc: Alan Jenkins <sourcejedi.lkml@googlemail.com>,
       linux-kernel@vger.kernel.org, Jan Blunck <jblunck@suse.de>,
       gregkh@suse.de, Harald Hoyer <harald@redhat.com>,
       Scott James Remnant <scott@ubuntu.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 6, 2009 at 02:06, Greg KH<greg@kroah.com> wrote:
> On Wed, Aug 05, 2009 at 09:55:49PM +0100, Alan Jenkins wrote:

>> > +                   err = vfs_mkdir(nd.path.dentry->d_inode,
>> > +                                   dentry, 0775);
>>
>> Is there a typo here?  I think the mode should be 0755.   0755 is used
>> below, and that does fit better with the 0600 mode for device nodes.
>
> Yeah, I think you are correct.  Kay, any objection to me making this
> change?

No, sure no objection. It sounds right to use 0755.
I was just waiting if more things to fix come up. :)

Thanks,
Kay
