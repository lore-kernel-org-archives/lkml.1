Return-Path: <linux-kernel-owner+w=401wt.eu-S932555AbYEMUun@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932555AbYEMUun (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2008 16:50:43 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760191AbYEMUuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 13 May 2008 16:50:22 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:42100 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757542AbYEMUuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2008 16:50:21 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Benjamin Thery " <Benjamin.Thery@bull.net>
Cc: Greg KH <greg@kroah.com>, "Eric W. Biederman" <ebiederm@xmission.com>,
       Randy Dunlap <randy.dunlap@oracle.com>, Greg KH <gregkh@suse.de>,
       Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
       Tejun Heo <htejun@gmail.com>, Al Viro <viro@ftp.linux.org.uk>,
       Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, netdev@vger.kernel.org
References: <m163tocw43.fsf_-_@frodo.ebiederm.org>
	<20080512220232.GA16914@kroah.com> <m1prrqbseh.fsf@frodo.ebiederm.org>
	<4829A4BD.3020007@bull.net> <20080513164438.GA31563@kroah.com>
	<20080513213330.utev64tlw4ss0kgw@intran0x.frec.bull.fr>
Date: Tue, 13 May 2008 13:42:59 -0700
In-Reply-To: <20080513213330.utev64tlw4ss0kgw@intran0x.frec.bull.fr> (Benjamin
	Thery's message of "Tue, 13 May 2008 21:33:30 +0200")
Message-ID: <m1wsly9bqk.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0001]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: kobject: Fix kobject_rename and !CONFIG_SYSFS
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Benjamin Thery " <Benjamin.Thery@bull.net> writes:

> That's what I did first. But I thought it was worse than the above
> solution.
> Anyway, adding kobject_set_name() to sysfs.h did fix the error.

I figure sorting out the headers is worth while, but that is
another project.

Because kobject.h includes sysfs.h we can't get the declarations
out of sync which is the really important part.

Eric
