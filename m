Return-Path: <linux-kernel-owner+w=401wt.eu-S1753573AbZAKOSx@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753573AbZAKOSx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jan 2009 09:18:53 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751397AbZAKOSn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 11 Jan 2009 09:18:43 -0500
Received: from mtagate1.de.ibm.com ([195.212.17.161]:36329 "EHLO
	mtagate1.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751352AbZAKOSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jan 2009 09:18:41 -0500
From: Christian Borntraeger <borntraeger@de.ibm.com>
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: [Bug #12422] 2.6.28-git can't resume from str
Date: Sun, 11 Jan 2009 15:18:38 +0100
User-Agent: KMail/1.9.9
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Jeff Chua <jeff.chua.linux@gmail.com>, Phil Dibowitz <phil@ipom.com>
References: <XU-8icArWLM.A.UpG.8GfaJB@chimera> <oWTznAnH9BI.A.qDH.EHfaJB@chimera> <4969FD64.8040408@gentoo.org>
In-Reply-To: <4969FD64.8040408@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200901111518.38880.borntraeger@de.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 11 Januar 2009 schrieb Daniel Drake:
> Rafael J. Wysocki wrote:
> > This message has been generated automatically as a part of a report
> > of recent regressions.
> > 
> > The following bug entry is on the current list of known regressions
> > from 2.6.28.  Please verify if it still should be listed and let me know
> > (either way).
> > 
> > 
> > Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=12422
> > Subject		: 2.6.28-git can't resume from str
> > Submitter	: Jeff Chua <jeff.chua.linux@gmail.com>
> > Date		: 2009-01-10 1:39 (2 days old)
> > References	: http://marc.info/?l=linux-kernel&m=123155157909282&w=4
> 
> The bisection looks invalid. It is unlikely to be this commit at fault. 
> Jeff, do you even have that camera?
> 
> It is also easy to revert that commit by hand. Just delete the 
> unusual_devs entry for it.

I found a nearby commit during bisect, which looks much saner:

http://marc.info/?l=linux-kernel&m=123167815028388&w=2
