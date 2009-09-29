Return-Path: <linux-kernel-owner+w=401wt.eu-S1753785AbZI2SxD@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753785AbZI2SxD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Sep 2009 14:53:03 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753501AbZI2SxC
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 29 Sep 2009 14:53:02 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56300 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313AbZI2SxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Sep 2009 14:53:01 -0400
Message-ID: <4AC255A4.4030002@zytor.com>
Date: Tue, 29 Sep 2009 11:44:52 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.1) Gecko/20090814 Fedora/3.0-2.6.b3.fc11 Thunderbird/3.0b3
MIME-Version: 1.0
To: Roland McGrath <roland@redhat.com>
CC: Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
       Arnd Bergmann <arnd@arndb.de>,
       Containers <containers@lists.linux-foundation.org>,
       Nathan Lynch <nathanl@austin.ibm.com>, linux-kernel@vger.kernel.org,
       "Eric W. Biederman" <ebiederm@xmission.com>, mingo@elte.hu,
       torvalds@linux-foundation.org, Alexey Dobriyan <adobriyan@gmail.com>,
       Pavel Emelyanov <xemul@openvz.org>, linux-api@vger.kernel.org,
       kosaki.motohiro@jp.fujitsu.com
Subject: Re: [RFC][v7][PATCH 8/9]: Define clone2() syscall
References: <20090924165548.GA16586@us.ibm.com>	<20090924170308.GH16989@us.ibm.com>	<200909242343.59903.arnd@arndb.de>	<20090925082346.GB4436@localdomain>	<20090925105632.GG12824@hawkmoon.kerlabs.com>	<20090929180537.GD4625@us.ibm.com> <20090929184023.532DF34@magilla.sf.frob.com>
In-Reply-To: <20090929184023.532DF34@magilla.sf.frob.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/29/2009 11:40 AM, Roland McGrath wrote:
> Why add a new syscall at all instead of just using a new CLONE_* flag to
> indicate that the argument layout is different?

What an absolutely atrociously bad idea.

We already have a syscall layer which is painful to thunk in places, and
this would make it much worse.

	-hpa

