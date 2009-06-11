Return-Path: <linux-kernel-owner+w=401wt.eu-S1762975AbZFKO2v@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762975AbZFKO2v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Jun 2009 10:28:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752465AbZFKO2l
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 11 Jun 2009 10:28:41 -0400
Received: from mail-gx0-f214.google.com ([209.85.217.214]:59151 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbZFKO2k convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Jun 2009 10:28:40 -0400
MIME-Version: 1.0
In-Reply-To: <20090414215342.GB9877@ovro.caltech.edu>
References: <20090224000002.GA578@ovro.caltech.edu> <fa686aa40904141328oa57fb1bsffd0549a52eca90@mail.gmail.com> 
	<20090414215342.GB9877@ovro.caltech.edu>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Thu, 11 Jun 2009 08:22:54 -0600
Message-ID: <fa686aa40906110722y1b4b8c22l7ccdd32d6684324d@mail.gmail.com>
Subject: Re: [RFC v2] virtio: add virtio-over-PCI driver
To: Ira Snyder <iws@ovro.caltech.edu>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
       Rusty Russell <rusty@rustcorp.com.au>,
       Jan-Bernd Themann <THEMANN@de.ibm.com>, linuxppc-dev@ozlabs.org,
       netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 14, 2009 at 3:53 PM, Ira Snyder<iws@ovro.caltech.edu> wrote:
> On Tue, Apr 14, 2009 at 02:28:26PM -0600, Grant Likely wrote:
>> On Mon, Feb 23, 2009 at 6:00 PM, Ira Snyder <iws@ovro.caltech.edu> wrote:
>> > This adds support to Linux for using virtio between two computers linked by
>> > a PCI interface. This allows the use of virtio_net to create a familiar,
>> > fast interface for communication. It should be possible to use other virtio
>> > devices in the future, but this has not been tested.
>>
>> Hey Ira,
>>
>> I like this a lot.  I need to do much the same thing on one of my
>> platforms, so I'm going to use your patch as my starting point.  Have
>> you made many changes since you posted this version of your patch?
>> I'd like to collaborate on the development and help to get it
>> mainlined.
>>
>
> This would be great. I'd really appreciate the help. I haven't had time
> to make any changes since I last posted the patch. I started work on
> converting all of the usage of struct vop_loc_* to just use the on-wire
> structures, but I didn't get very far before other work got in the way.
>
>> In my case I've got an MPC5200 as the 'host' and a Xilinx Virtex
>> (ppc440) as the 'client'.  I intend set aside a region of the Xilinx
>> Virtex's memory space for the shared queues.  I'm starting work on it
>> now, and I'll provide you with feedback and/or patches as I make
>> progress.
>>
>
> I'm looking forward to seeing your implementation. If you have any
> questions, I'd be happy to attempt to answer them :)

Hey Ira,

I've been slowly hacking on your virtio-over-pci stuff.  I've got an
initial series of cleanup patches which address some of the comments
from this thread.  Before I send them to you, have you made any
changes on your end?  They likely won't apply without changes to the
core code, so I'd like to sync up with you first.

Cheers,
g.


-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
