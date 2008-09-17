Return-Path: <linux-kernel-owner+w=401wt.eu-S1755631AbYIQVph@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755631AbYIQVph (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2008 17:45:37 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753592AbYIQVpZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Sep 2008 17:45:25 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:42872 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753164AbYIQVpX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2008 17:45:23 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Paul Moore <paul.moore@hp.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
       Stephen Smalley <sds@tycho.nsa.gov>, jmorris@namei.org, rjw@sisk.pl,
       linux-kernel@vger.kernel.org, kernel-testers@vger.kernel.org,
       netdev@vger.kernel.org
References: <j3zWxt-CgYL.A.WTF.bbsyIB@albercik>
	<1221483926.30816.18.camel@moss-spartans.epoch.ncsc.mil>
	<20080917125053.1f9ecf37.akpm@linux-foundation.org>
	<200809171724.36269.paul.moore@hp.com>
Date: Wed, 17 Sep 2008 14:39:45 -0700
In-Reply-To: <200809171724.36269.paul.moore@hp.com> (Paul Moore's message of
	"Wed, 17 Sep 2008 17:24:36 -0400")
Message-ID: <m1vdwu4fku.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: too long (recipient list exceeded maximum allowed size of 128 bytes)
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Paul Moore <paul.moore@hp.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0462]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [Bug #11500] /proc/net bug related to selinux
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Moore <paul.moore@hp.com> writes:

> We suck?  Maybe, but some explanation about why we suck in this 
> particular case would be helpful as far as I'm concerned.  I don't 
> really care about identifying the guilty suckees, I'm more interested 
> in finding out what happened to cause us to suck because of this.

Agreed.  I believe we carefully gave selinux the same paths for /proc/net
that it had before so I don't know why this affects user space.

I know we had some selinux review when we made the change.

Eric
