Return-Path: <linux-kernel-owner+w=401wt.eu-S1030297AbXBLWpa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030297AbXBLWpa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 17:45:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030291AbXBLWp3
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 17:45:29 -0500
Received: from web50104.mail.yahoo.com ([206.190.38.32]:23640 "HELO
	web50104.mail.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1030288AbXBLWpZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 17:45:25 -0500
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:Date:From:Subject:To:Cc:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-ID;
  b=HMIqY76dakWO5X9mMXvzA9OpAPtlcW/LMwPlM45RNaeM/ZHgA3G0ED4+aYjO6uPpbEb/H/l4U4OiR+Yw3yOZAJJ3zqNznOAboZvDBXcKWrn8lVapBhylD0myKZIuwgX8ZMmljbPtWtruWqtHV9zoNVLbKraZy5zDLEudAyRhOQA=;
X-YMail-OSG: c3Y0XAEVM1lIv8heCJrl35Rg_lEObRR823sKYNHvncU5soXZ.8OqgOa8ZJjqT4vd2JW13l.D8NBQw.AVtJ2sx2d4b_znuDaXJmXjOSwotjOi6OglTEOvyNoQVkARvus9tElvJjOw94I-
Date: Mon, 12 Feb 2007 14:45:24 -0800 (PST)
From: Doug Thompson <norsk5@yahoo.com>
Subject: Re: -mm merge plans for 2.6.21
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan <alan@lxorguk.ukuu.org.uk>, Andrew Morton <akpm@linux-foundation.org>,
       linux-kernel@vger.kernel.org
In-Reply-To: <200702122246.38703.andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Message-ID: <180144.45981.qm@web50104.mail.yahoo.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org


--- Andi Kleen <andi@firstfloor.org> wrote:
> > As to the size of the MCE code doing everything EDAC K8 does, that
> is
> > mostly true. BUT then the x86_64 MCE mechanism becomes the
> exception
> > path. 
> 
> Sorry you lost me on that one.
> 
> -Andi

In similiar manner of the original SATA driver model, the one that
didn't use the SCSI stack. Then the SATA model was enhanced to fit
under SCSI, then the SATA drivers ported to run under the SATA module.
At that point, the original SATA driver model was an exception to the
SATA model.

Yes, if all the world used the hardware MCE mechanism, then the MCE
device probably would satisify the requirements. But since linux runs
across so many architectures and processors, the export of a single
architecture's mechanism then implies that a second interface is
necessary anyway in order to provide for those "other" archs. 

At that point we then move the abstraction into userspace anyway.
Scripts will then need to "know" which arch they are on, in order to
pull ECC events from one or the other interface.

Thus, where is the line as to where the "portable" abstraction "fits"?

thanks for your comments

doug t


