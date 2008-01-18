Return-Path: <linux-kernel-owner+w=401wt.eu-S1764243AbYARSZd@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764243AbYARSZd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2008 13:25:33 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763812AbYARSZO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 18 Jan 2008 13:25:14 -0500
Received: from mx01.xsigo.com ([216.184.49.20]:56345 "EHLO mx01.xsigo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1763746AbYARSZM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2008 13:25:12 -0500
Subject: RE: [ofa-general] InfiniBand/RDMA merge plans for 2.6.25
From: Hal Rosenstock <hrosenstock@xsigo.com>
To: Sean Hefty <sean.hefty@intel.com>
Cc: Roland Dreier <rdreier@cisco.com>, linux-kernel@vger.kernel.org,
       general@lists.openfabrics.org
In-Reply-To: <000001c859f9$7bc7f590$ff0da8c0@amr.corp.intel.com>
References: <ada7ii8xaao.fsf@cisco.com>
	 <1200676232.1486.88.camel@hrosenstock-ws.xsigo.com>
	 <000001c859f9$7bc7f590$ff0da8c0@amr.corp.intel.com>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Date: Fri, 18 Jan 2008 10:25:11 -0800
Message-Id: <1200680711.1486.104.camel@hrosenstock-ws.xsigo.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.0.2 (2.0.2-27) 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-01-18 at 09:42 -0800, Sean Hefty wrote:
> >> Sean Hefty (6):
> >>       IB/mad: Fix incorrect access to items on local_list
> >
> >It wasn't clear to me that this issue was ever really nailed. Was the
> >loop on this closed ?
> 
> The error that this patches addresses is fairly obvious if you inspect the code.

The bug seems obvious but I'm not sure about the fix. Just my $0.02
worth.

-- Hal

> There's a strong chance that the patch fixes the bug that was reported, but the
> last I remember, they had trouble reproducing the crash to see if the patch
> would indeed make it go away.
> 
> - Sean
