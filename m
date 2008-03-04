Return-Path: <linux-kernel-owner+w=401wt.eu-S1764140AbYCDMyq@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764140AbYCDMyq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 07:54:46 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756923AbYCDMyf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 07:54:35 -0500
Received: from ug-out-1314.google.com ([66.249.92.175]:32138 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbYCDMye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 07:54:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject:references:in-reply-to:x-enigmail-version:content-type:content-transfer-encoding;
        b=XMJogCBZYaqCgRCdW6bjklLydS9jU2Qt9+h2UPDrxPwqe7n1DJsx0jJ/3i/DALGPVfzN1wjM3MSKbAbd9xkvVVGcPVlkmMqPpRieBpMQQPW7g7PqADiZDOAsPM4L5VCqEbIMngS/XMNPYsAksxO5lUsHCbrNBaFb7PonwOAwEmQ=
Message-ID: <47CD46B5.7050509@gmail.com>
Date: Tue, 04 Mar 2008 13:55:17 +0100
From: Jiri Slaby <jirislaby@gmail.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080213)
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Andrew Morton <akpm@linux-foundation.org>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       linux-ext4@vger.kernel.org, Jan Sonnek <xsonnek@fi.muni.cz>,
       Christoph Lameter <clameter@sgi.com>
Subject: Re: [2.6.25-rc2-mm1] Oops in __kmalloc
References: <47C42DDF.3060506@gmail.com>	 <20080226100913.9412b41c.akpm@linux-foundation.org>	 <47CD2753.5050905@gmail.com> <84144f020803040451u562eb378h2d6c2378d1b174fe@mail.gmail.com>
In-Reply-To: <84144f020803040451u562eb378h2d6c2378d1b174fe@mail.gmail.com>
X-Enigmail-Version: 0.95.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Pekka Enberg napsal(a):
> On Tue, Mar 4, 2008 at 12:41 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
>>  >> while booting up a notebook on 32 bit, this oopses appeared on the console
>>  >> after ext3 fsck:
>>  >> http://www.fi.muni.cz/~xslaby/sklad/mem_oops/
>>  >>
>>  >> It's 2.6.25-rc2-mm1, I can't find similar reports, is this known or hardware
>>  >> issue (unlikely, 2.6.24.2 seems to be OK)?
>>  >
>>  > I don't recall seeing a similar report and yes, it'll be a kernel bug.
>>  >
>>  > We've fixed a few things and it could be that this will just go away in
>>  > next -mm.  If it doesn't, a bisection search would be good, thanks.
>>
>>  Well, next -mm is out. Could you test, Jan? [our -mm git is up-to-date]
> 
> I don't see your config but if you have CONFIG_SLUB enabled, this is
> probably the same problem as:
> 
> http://bugzilla.kernel.org/show_bug.cgi?id=10015
> 
> which is fixed since 2.6.25-rc2 in mainline.

Yeah, slub armed. We'll see. Thanks.
