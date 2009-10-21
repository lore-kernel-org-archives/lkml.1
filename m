Return-Path: <linux-kernel-owner+w=401wt.eu-S1754952AbZJUVLz@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952AbZJUVLz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Oct 2009 17:11:55 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753877AbZJUVLy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 Oct 2009 17:11:54 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:35701 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753724AbZJUVLx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Oct 2009 17:11:53 -0400
To: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>
Cc: Matt Helsley <matthltc@us.ibm.com>, Oren Laadan <orenl@librato.com>,
       Daniel Lezcano <daniel.lezcano@free.fr>, randy.dunlap@oracle.com,
       arnd@arndb.de, linux-api@vger.kernel.org,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       Louis.Rilling@kerlabs.com, kosaki.motohiro@jp.fujitsu.com,
       hpa@zytor.com, mingo@elte.hu, torvalds@linux-foundation.org,
       Alexey Dobriyan <adobriyan@gmail.com>, roland@redhat.com,
       Pavel Emelyanov <xemul@openvz.org>
Subject: Re: [RFC][v8][PATCH 0/10] Implement clone3() system call
References: <4ADCCD68.9030003@free.fr> <4ADCDE7F.4090501@librato.com>
	<20091020005125.GG27627@count0.beaverton.ibm.com>
	<m1vdiad9jd.fsf@fess.ebiederm.org> <20091020040315.GA26632@us.ibm.com>
	<m1iqeauyvl.fsf@fess.ebiederm.org> <20091020183329.GB22646@us.ibm.com>
	<m1r5sxsw7w.fsf@fess.ebiederm.org> <20091021062021.GA2667@us.ibm.com>
	<m1eioxrtsb.fsf@fess.ebiederm.org> <20091021185242.GB12955@us.ibm.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Wed, 21 Oct 2009 14:11:49 -0700
In-Reply-To: <20091021185242.GB12955@us.ibm.com> (Sukadev Bhattiprolu's message of "Wed\, 21 Oct 2009 11\:52\:42 -0700")
Message-ID: <m18wf4sb8q.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in02.mta.xmission.com;;;ip=76.21.114.89;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 76.21.114.89
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Version: 4.2.1 (built Thu, 25 Oct 2007 00:26:12 +0000)
X-SA-Exim-Scanned: No (on in02.mta.xmission.com); Unknown failure
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com> writes:

> Eric W. Biederman [ebiederm@xmission.com] wrote:
> | Not what I was thinking.  The following untested patch is what I was
> | thinking.  It just exposes last, min, and max to the callers which pass
> | in different appropriate values.
>
>
> Minor comments are that the caller has to choose which function to call
> and passing in 'target-1' for the 'last' in set_pidmap() seems a bit
> unnatural. But I can't think of a better way and I think this will work.
> Will test it out.

Thanks.  My primary concern was that we don't unnecessarily duplicate all
of the weird allocating a bitmap page code etc.

