Return-Path: <linux-kernel-owner+w=401wt.eu-S932917AbYEHTaw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932917AbYEHTaw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2008 15:30:52 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755766AbYEHTaK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 8 May 2008 15:30:10 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:48718 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752147AbYEHTaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2008 15:30:04 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Cornelia Huck <cornelia.huck@de.ibm.com>
Cc: Greg KH <gregkh@suse.de>, Benjamin Thery <benjamin.thery@bull.net>,
       linux-kernel@vger.kernel.org, Tejun Heo <htejun@gmail.com>,
       Al Viro <viro@ftp.linux.org.uk>, Daniel Lezcano <dlezcano@fr.ibm.com>,
       "Serge E. Hallyn" <serue@us.ibm.com>,
       Pavel Emelyanov <xemul@openvz.org>, netdev@vger.kernel.org
References: <20080506173030.653828076@theryb.frec.bull.fr>
	<20080506173335.922289888@theryb.frec.bull.fr>
	<m13aoueyq8.fsf@frodo.ebiederm.org> <20080507190838.GA4467@suse.de>
	<m1hcd9esxo.fsf@frodo.ebiederm.org>
	<20080508102844.25642ef7@gondolin.boeblingen.de.ibm.com>
Date: Thu, 08 May 2008 12:28:19 -0700
In-Reply-To: <20080508102844.25642ef7@gondolin.boeblingen.de.ibm.com>
	(Cornelia Huck's message of "Thu, 8 May 2008 10:28:44 +0200")
Message-ID: <m1myn0d298.fsf@frodo.ebiederm.org>
User-Agent: Gnus/5.110006 (No Gnus v0.6) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-SA-Exim-Connect-IP: 24.130.11.59
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-DCC: XMission; sa04 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Report: * -1.8 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -2.6 BAYES_00 BODY: Bayesian spam probability is 0 to 1%
	*      [score: 0.0006]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa04 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.0 XM_SPF_Neutral SPF-Neutral
Subject: Re: [PATCH 10/11] avoid kobject name conflict with different namespaces
X-SA-Exim-Version: 4.2 (built Thu, 03 Mar 2005 10:44:12 +0100)
X-SA-Exim-Scanned: Yes (on mgr1.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cornelia Huck <cornelia.huck@de.ibm.com> writes:

> On Wed, 07 May 2008 13:54:27 -0700,
> ebiederm@xmission.com (Eric W. Biederman) wrote:
>
>> > I thought that s390 also used it, but I don't see
>> > that usage in the tree anymore, perhaps they switched to something else.
>> 
>> That is the device_move -> kobject_move case. 
>
> Yes. bluetooth also uses it, IIRC.

Yes.

>> Very similar (and nice
>> if we can figure out how to combine them).
>
> Sounds like a good idea. I can test the _move() stuff (after I've
> managed to find some time to try this patchset...)

Do you remember if we have ever sorted out the race between _move
and module unload/directory teardown at the sysfs level?

Eric
