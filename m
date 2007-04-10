Return-Path: <linux-kernel-owner+w=401wt.eu-S1031324AbXDJSAF@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031324AbXDJSAF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2007 14:00:05 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1031330AbXDJSAF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Apr 2007 14:00:05 -0400
Received: from warden-p.diginsite.com ([208.29.163.248]:44497 "HELO
	warden.diginsite.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with SMTP id S1031324AbXDJSAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2007 14:00:03 -0400
Date: Tue, 10 Apr 2007 10:29:41 -0700 (PDT)
From: David Lang <david.lang@digitalinsight.com>
X-X-Sender: dlang@dlang.diginsite.com
To: Olaf Hering <olaf@aepfle.de>
cc: Gene Heskett <gene.heskett@gmail.com>, linux-kernel@vger.kernel.org,
       Dave Dillow <dave@thedillows.org>, Dave Jones <davej@redhat.com>,
       Jan Engelhardt <jengelh@linux01.gwdg.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Jeff Garzik <jeff@garzik.org>
Subject: Re: I give up
In-Reply-To: <20070410160817.GA32747@aepfle.de>
Message-ID: <Pine.LNX.4.63.0704101028480.27318@qynat.qvtvafvgr.pbz>
References: <200704091007.58535.gene.heskett@gmail.com> 
 <1176169246.3193.2.camel@obelisk.thedillows.org>  <20070410071217.GA28899@aepfle.de>
  <200704100351.33699.gene.heskett@gmail.com> <20070410160817.GA32747@aepfle.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2007, Olaf Hering wrote:

> On Tue, Apr 10, Gene Heskett wrote:
>
>> On Tuesday 10 April 2007, Olaf Hering wrote:
>>> On Mon, Apr 09, Dave Dillow wrote:
>>>> It's not /dev he's backing up -- its /home, /usr, and others. GNU tar
>>>> saves the device and inode numbers from the {,l}stat() call on each
>>>> file and decides it is a new file if either number changes from run to
>>>> run.
>>>
>>> So fix tar to not do silly things.
>>> Kernel major:minor numbers are not stable.
>
> I forgot to add: '.. not stable across reboots.'
>
>> YOU Tell that to the tar/star people, they are flabbergasted that its not
>> stable.  It apparently is for every other OS tar can be run on.
>
> They probably have a point with the st_dev usage.
> You better find out why your major:minor pairs keep jumping around.
> Simply because the 'not stable across reboot' statement holds only for
> added/removed disks and maybe if the detection order changes.
> If your setup relies on a certain order, make sure the drivers get
> loaded in a fixed order. Its not clear from your other mails what
> exactly caused it. If its only due to a temporary change in
> testkernels, noone can do anything about it.

he's running into problems when he adds additional drivers to the kernel (I 
don't remember which drivers, he's mentioned them earlier in this thread)

David Lang
