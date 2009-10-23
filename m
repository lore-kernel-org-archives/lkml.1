Return-Path: <linux-kernel-owner+w=401wt.eu-S1751956AbZJWXMZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751956AbZJWXMZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Oct 2009 19:12:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751504AbZJWXMY
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 23 Oct 2009 19:12:24 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:50168 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217AbZJWXMX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Oct 2009 19:12:23 -0400
To: Oren Laadan <orenl@librato.com>
Cc: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>, randy.dunlap@oracle.com,
       arnd@arndb.de, linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, kosaki.motohiro@jp.fujitsu.com,
       hpa@zytor.com, mingo@elte.hu, Pavel Emelyanov <xemul@openvz.org>,
       torvalds@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>,
       roland@redhat.com
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
References: <20091020005125.GG27627@count0.beaverton.ibm.com>
	<m1vdiad9jd.fsf@fess.ebiederm.org> <20091020040315.GA26632@us.ibm.com>
	<m1iqeauyvl.fsf@fess.ebiederm.org> <20091020183329.GB22646@us.ibm.com>
	<m1r5sxsw7w.fsf@fess.ebiederm.org> <20091021062021.GA2667@us.ibm.com>
	<m1eioxrtsb.fsf@fess.ebiederm.org> <20091023004253.GA7915@us.ibm.com>
	<m1bpjyrkep.fsf@fess.ebiederm.org> <20091023053001.GA24972@us.ibm.com>
	<4AE20124.4010108@librato.com> <4AE20532.6060809@librato.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Fri, 23 Oct 2009 16:12:19 -0700
In-Reply-To: <4AE20532.6060809@librato.com> (Oren Laadan's message of "Fri\, 23 Oct 2009 15\:34\:10 -0400")
Message-ID: <m1eiotogbw.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Oren Laadan <orenl@librato.com> writes:


> I stand corrected by Suka: a pid-specific clone does not change
> last_pid. Therefore, given that 'restart' only creates tasks with
> pid-specific clone, this should be safe for c/r.

Exactly.  We can preserve the existing guarantees and keep the ability
to restore any pid (at least in a fresh pid namespace).

Eric
