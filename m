Return-Path: <linux-kernel-owner+w=401wt.eu-S1762006AbXEXFVQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762006AbXEXFVQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2007 01:21:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756721AbXEXFVG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 24 May 2007 01:21:06 -0400
Received: from ug-out-1314.google.com ([66.249.92.172]:8077 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757533AbXEXFVE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2007 01:21:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:subject:from:to:cc:in-reply-to:references:content-type:date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=BQlEgxUCnwjSsFNxwoSl4Nag07wwrvDWFYveEVfdiI5EfP0iFyeJ4yVZ1iwK22HeocbUFm2UXinUBEQL+bHMtYcitZ3I6qOAkRHdflX79NQK3Orin9AhmMcGPVXTSzx+aDMw9YAZdCvN3kOD5TY/LKDNNftKK33t+GSIWO3QOyw=
Subject: Re: 2.6.21.1 fails to suspend/resume  to disk  (sort of)
From: Romano Giannetti <romano.giannetti@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Pavel Machek <pavel@ucw.cz>
In-Reply-To: <200705231857.33012.rjw@sisk.pl>
References: <1179905115.7043.25.camel@localhost>
	 <200705231105.08408.rjw@sisk.pl> <1179914262.7043.56.camel@localhost>
	 <200705231857.33012.rjw@sisk.pl>
Content-Type: text/plain
Date: Thu, 24 May 2007 07:20:58 +0200
Message-Id: <1179984058.12599.1.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2007-05-23 at 18:57 +0200, Rafael J. Wysocki wrote:
> On Wednesday, 23 May 2007 11:57, Romano Giannetti wrote:
> > On Wed, 2007-05-23 at 11:05 +0200, Rafael J. Wysocki wrote:
> > > Hi,
> > > 
> > > On Wednesday, 23 May 2007 09:25, Romano Giannetti wrote:
> > > > http://lkml.org/lkml/2007/5/23/38
> > > 
> > > Please see http://bugzilla.kernel.org/show_bug.cgi?id=8456
> > > That seems to resemble the symptoms you describe.
> > > 
> > 
> > No, I don't think. The delay I observe is on resume (suspend is very
> > fast). Moreover, I have no SATA. It seems that my problem came from
> > pcmcia.
> 
> Hmm, there also is this patch: http://lkml.org/lkml/2007/5/22/434
> 
Neither this is related. My report was for a delay of 60 seconds on
resume, not an infinite delay. And I have no bluetooth here.

I will try to add some data to the bug and then will open a bugzilla
report.

Romano

