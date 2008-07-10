Return-Path: <linux-kernel-owner+w=401wt.eu-S1761256AbYGJTHE@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761256AbYGJTHE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2008 15:07:04 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1754387AbYGJTGx
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 10 Jul 2008 15:06:53 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:46494 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754380AbYGJTGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2008 15:06:52 -0400
Subject: Re: Checkpoint/restart (was Re: [PATCH 0/4] - v2 - Object creation
	with a specified id)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Serge E. Hallyn" <serue@us.ibm.com>, Oren Laadan <orenl@cs.columbia.edu>,
       Kirill Korotaev <dev@parallels.com>,
       containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Nadia.Derbey@bull.net, Andrew Morton <akpm@linux-foundation.org>,
       nick@nick-andrew.net, Alexey Dobriyan <adobriyan@gmail.com>
In-Reply-To: <m163rd1sd5.fsf@frodo.ebiederm.org>
References: <20080418054459.891481000@bull.net>
	 <20080422193612.GA15835@martell.zuzino.mipt.ru>
	 <1208890580.17117.14.camel@nimitz.home.sr71.net>
	 <20080422210130.GA15937@martell.zuzino.mipt.ru>
	 <1208904967.17117.51.camel@nimitz.home.sr71.net>
	 <480ED9D5.1010906@parallels.com> <480FE037.2010302@cs.columbia.edu>
	 <m1y74a7b4w.fsf@frodo.ebiederm.org> <1215709949.9398.15.camel@nimitz>
	 <20080710173246.GA1857@us.ibm.com>  <m163rd1sd5.fsf@frodo.ebiederm.org>
Content-Type: text/plain
Date: Thu, 10 Jul 2008 12:06:34 -0700
Message-Id: <1215716794.9398.41.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2008-07-10 at 11:55 -0700, Eric W. Biederman wrote:
> 
> > If we do checkpoint-as-a-coredump, then we need userspace to coordinate
> > a kernel-generated coredump with a user-generated (?) swapfile snapshot.
> > But I guess we figure that out later.
> 
> Well it is a matter of which VMAs you dump.  For things that are file backed
> you need to dump them.

Are we talking about the VMA itself, or the memory backing the VMA?

-- Dave

