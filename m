Return-Path: <linux-kernel-owner+w=401wt.eu-S1754708AbYIRLp2@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754708AbYIRLp2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2008 07:45:28 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752513AbYIRLpV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 18 Sep 2008 07:45:21 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:43052 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106AbYIRLpU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2008 07:45:20 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg K-H <greg@kroah.com>, linux-kernel <linux-kernel@vger.kernel.org>
References: <20080917130805.6260ba9c@gondolin.boeblingen.de.ibm.com>
	<m1r67i61rh.fsf@frodo.ebiederm.org>
	<20080918090705.6985cced@gondolin.boeblingen.de.ibm.com>
	<m17i99wz7k.fsf@frodo.ebiederm.org>
	<20080918125056.03c404e8@gondolin.boeblingen.de.ibm.com>
Date: Thu, 18 Sep 2008 04:37:34 -0700
In-Reply-To: <20080918125056.03c404e8@gondolin.boeblingen.de.ibm.com>
	(Cornelia Huck's message of "Thu, 18 Sep 2008 12:50:56 +0200")
Message-ID: <m1y71pvg5d.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=mx04.mta.xmission.com;;;ip=24.130.11.59;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Rcpt-To: cornelia.huck@de.ibm.com, linux-kernel@vger.kernel.org, greg@kroah.com
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Cornelia Huck <cornelia.huck@de.ibm.com>
X-Spam-Relay-Country: 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -1.1 BAYES_05 BODY: Bayesian spam probability is 1 to 5%
	*      [score: 0.0409]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH]sysfs: Don't emit a warning when sysfs_rename_link() fails.
X-SA-Exim-Version: 4.2.1 (built Thu, 07 Dec 2006 04:40:56 +0000)
X-SA-Exim-Scanned: Yes (on mx04.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck <cornelia.huck@de.ibm.com> writes:

> On Thu, 18 Sep 2008 03:00:31 -0700,
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> In the dev_change_name we either do dev_alloc_name
>> which generates a unique device name or __dev_get_by_name
>> which looks to see if we are already using that name.
>
> Duh, I overlooked that, sorry about the noise.

No problem.

> (OTOH, we should get of sysfs_do_create_link() then, since it's an
> unneed indirection).

No objection from me.

Eric

