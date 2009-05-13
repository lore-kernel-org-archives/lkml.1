Return-Path: <linux-kernel-owner+w=401wt.eu-S1759953AbZEMNJ6@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759953AbZEMNJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 May 2009 09:09:58 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752172AbZEMNJt
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 13 May 2009 09:09:49 -0400
Received: from mail-bw0-f222.google.com ([209.85.218.222]:35901 "EHLO
	mail-bw0-f222.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753155AbZEMNJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 May 2009 09:09:48 -0400
MIME-Version: 1.0
In-Reply-To: <1242219471.9974.18.camel@localhost.localdomain>
References: <20090509143742.GA27663@kroah.com> <ac3eb2510905111405y5541117euf84dd38d39012bd0@mail.gmail.com> 
	<1242132344.31807.48.camel@localhost.localdomain> <ac3eb2510905120810n101dff08yfa945a2ab4b17168@mail.gmail.com> 
	<1242142528.31807.80.camel@localhost.localdomain> <ac3eb2510905120854y7b44f608odf25af159fd6495c@mail.gmail.com> 
	<1242168913.6711.9.camel@poy> <1242217342.9974.10.camel@localhost.localdomain> 
	<ac3eb2510905130558s493d8c9m667348d183c97721@mail.gmail.com> 
	<1242219471.9974.18.camel@localhost.localdomain>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 13 May 2009 15:09:27 +0200
Message-ID: <ac3eb2510905130609g10043215xfc391658f7d151b3@mail.gmail.com>
Subject: Re: [patch 00/13] devtmpfs patches
To: Stephen Smalley <sds@tycho.nsa.gov>
Cc: "David P. Quigley" <dpquigl@tycho.nsa.gov>, Greg KH <greg@kroah.com>,
       linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Jan Blunck <jblunck@suse.de>, James Morris <jmorris@namei.org>,
       Eric Paris <eparis@parisplace.org>, David Howells <dhowells@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 13, 2009 at 14:57, Stephen Smalley <sds@tycho.nsa.gov> wrote:
>> Ok, good, will do that. Anything like this to keep in mind when
>> creating/removing simple subdirectories?
>
> Yes, any time you call any vfs helper (and thus are subject to the
> permission checking calls, both DAC and LSM/SELinux), you need to decide
> whether you truly want those permission checks to get applied against
> the current process' credentials or whether you should be using
> alternate credentials for the call.

Yeah, I see. I'll wrap the entire operation in the swapped
credentials, which should be the best option anyway.

Thanks a lot,
Kay
