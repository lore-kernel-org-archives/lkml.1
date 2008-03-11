Return-Path: <linux-kernel-owner+w=401wt.eu-S1755569AbYCKTX7@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbYCKTX7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Mar 2008 15:23:59 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752584AbYCKTXr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 11 Mar 2008 15:23:47 -0400
Received: from fg-out-1718.google.com ([72.14.220.159]:59114 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751617AbYCKTXq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Mar 2008 15:23:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:message-id;
        b=ZdxqIZMN2cBDCH7cqizWn2HHl7Q90bTpDfQrygEhXo01ERcY+MPgPmBZ6cELBveQTb/cFOMVR7r0m2m4w4/ctFSvI4UUM4iCodYMR5E14RH+Qn31pFGcioLW/8zWpyT/Nn8WCrbaII5x7oZwJQjJaceAameVEEC010A/6qsj67A=
From: Bartlomiej Zolnierkiewicz <bzolnier@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Build Failure] 2.6.25-rc5-mm1 Build fails with allmodconfig probe_4drives undefined
Date: Tue, 11 Mar 2008 20:35:24 +0100
User-Agent: KMail/1.9.9
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
       linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
       apw@shadowen.org
References: <20080311011434.ad8c8d7d.akpm@linux-foundation.org> <47D68126.40109@linux.vnet.ibm.com> <20080311104137.3c6b3f22.akpm@linux-foundation.org>
In-Reply-To: <20080311104137.3c6b3f22.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200803112035.24811.bzolnier@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 11 March 2008, Andrew Morton wrote:
> On Tue, 11 Mar 2008 18:25:02 +0530
> Kamalesh Babulal <kamalesh@linux.vnet.ibm.com> wrote:
> 
> > The 2.6.25-rc5-mm1 kernel build fails with allmodconfig 
> > 
> >   MODPOST 2279 modules
> > ERROR: "probe_4drives" [drivers/ide/ide-core.ko] undefined!
> 
> Yes, it has been doing this for a while.  But apparently it doesn't happen
> for Bart with just his patch queue.  <slightlypeeved>If your subssytem
> fails in my tree, that doesn't automatically make it my
> problem</slightlypeeved>

No need to peeve - it is not like I forget about the problem or ignored it
after I got your _first_ mail.

I just couldn't reproduce it here so instead I has been working on making
_all_ probe_* variables static (it should make the problem vanish alongside
some other nice improvements).

Thanks,
Bart
