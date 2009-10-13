Return-Path: <linux-kernel-owner+w=401wt.eu-S1753331AbZJMQqK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331AbZJMQqK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Oct 2009 12:46:10 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbZJMQqJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 Oct 2009 12:46:09 -0400
Received: from claw.goop.org ([74.207.240.146]:35463 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752748AbZJMQqI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Oct 2009 12:46:08 -0400
Message-ID: <4AD4AEAA.2080209@goop.org>
Date: Tue, 13 Oct 2009 09:45:30 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20090922 Fedora/3.0-2.7.b4.fc11 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: James Bottomley <James.Bottomley@suse.de>
CC: akataria@vmware.com, Randy Dunlap <randy.dunlap@oracle.com>,
       Mike Christie <michaelc@cs.wisc.edu>,
       Bart Van Assche <bvanassche@acm.org>,
       "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>,
       "pv-drivers@vmware.com" <pv-drivers@vmware.com>,
       Roland Dreier <rdreier@cisco.com>, Greg KH <gregkh@suse.de>,
       LKML <linux-kernel@vger.kernel.org>,
       "virtualization@lists.linux-foundation.org" 
	<virtualization@lists.linux-foundation.org>,
       Chris Wright <chrisw@sous-sol.org>,
       "Chetan.Loke@Emulex.Com" <Chetan.Loke@Emulex.Com>,
       Daniel Walker <dwalker@fifo99.com>,
       Rolf Eike Beer <eike-kernel@sf-tec.de>,
       Robert Love <robert.w.love@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>
Subject: Re: SCSI driver for VMware's virtual HBA - V5.
References: <1254336812.19921.23.camel@ank32.eng.vmware.com>	<20091002004725.GP3958@sequoia.sous-sol.org>	<1254789028.15233.54.camel@ank32.eng.vmware.com> <1255444557.2855.95.camel@localhost.localdomain>
In-Reply-To: <1255444557.2855.95.camel@localhost.localdomain>
X-Enigmail-Version: 0.97a
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/13/09 07:35, James Bottomley wrote:
>> Yep, below is a patch with the rename, the driver is now called
>> vmw_pvscsi. Do let me know if you have any other comments. Thanks.
>>     
> I'm still curious to know what the 'p' in the name stands for.  Surely
> this is a fully virtual driver, not a paravirtual one?
>   

I would assume that "pv" does stand for paravirtual.  The terminology is
a bit screwy: "fully virtualized" means that the device looks like a
real hardware device that is being emulated.  "Paravirtualized" means
that it is a completely virtual device which isn't an emulation of
anything; the guests know this this and talk to it accordingly.

    J

