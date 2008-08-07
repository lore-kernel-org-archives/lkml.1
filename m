Return-Path: <linux-kernel-owner+w=401wt.eu-S1754161AbYHGPyD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754161AbYHGPyD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Aug 2008 11:54:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751788AbYHGPxy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 7 Aug 2008 11:53:54 -0400
Received: from outbound-mail-35.bluehost.com ([69.89.18.155]:60424 "HELO
	outbound-mail-35.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752508AbYHGPxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Aug 2008 11:53:54 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:From:To:Subject:Date:User-Agent:Cc:References:In-Reply-To:MIME-Version:Content-Type:Content-Transfer-Encoding:Content-Disposition:Message-Id:X-Identified-User;
	b=BNQNHEEwdPa+OlGGPMh0Qe8Lgh1GLrvibriqALlOQyc2ILIFrvX27Qtwx85jbVSYd9gcY5iYZJ6OCwf3HPQIa073BoaOidqlfRIWQus+0x04+a01VlbuGJ8S20QkRd55;
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
Subject: Re: [Bug #11178] Secondary hard drive fails during both hibernation and resume.
Date: Thu, 7 Aug 2008 08:53:41 -0700
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Matthew Wilcox <matthew@wil.cx>, Matthew Wilcox <willy@linux.intel.com>
References: <cbItfVMShGI.A.olC.UMLlIB@albercik> <5ZeQ4vXWqRC.A.q2E.4NLlIB@albercik> <48956E15.6070409@tuffmail.co.uk>
In-Reply-To: <48956E15.6070409@tuffmail.co.uk>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808070853.42957.jbarnes@virtuousgeek.org>
X-Identified-User: {642:box128.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.27.49 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, August 3, 2008 1:36 am Alan Jenkins wrote:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> >
> > The following bug entry is on the current list of known regressions
> > from 2.6.26.  Please verify if it still should be listed
> > and let me know (either way).
> >
> >
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=11178
> > Subject		: Secondary hard drive fails during both hibernation and resume.
> > Submitter	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> > Date		: 2008-07-30 04:53 (4 days old)
> > Handled-By	: Alan Jenkins <alan-jenkins@tuffmail.co.uk>
> > Patch		: http://bugzilla.kernel.org/attachment.cgi?id=17043&action=view
>
> Please keep listed.
>
> The problem and patch are recently confirmed by Hugh Dickins (on LKML)
> and Dionisus Torimens (bugzilla duplicate).

I took a look at this yesterday.  I don't think this is the only thing wrong 
with the MSI code at this point (there are a couple of other improvements and 
potential problems there), but your fix looks good.  I just applied it to my 
for-linus tree.  I'll ask Linus to pull after it's had a little time in 
linux-next.

Thanks,
Jesse
