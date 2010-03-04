Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab0CDUXb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 15:23:31 -0500
Received: from casper.infradead.org ([85.118.1.10]:60357 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab0CDUX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 15:23:29 -0500
Subject: Re: [RFC][PATCH 08/11] perf, x86: Implement simple LBR support
From: Peter Zijlstra <peterz@infradead.org>
To: Stephane Eranian <eranian@google.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, paulus@samba.org,
       robert.richter@amd.com, fweisbec@gmail.com
In-Reply-To: <1267726733.25158.219.camel@laptop>
References: <20100303163936.906011640@chello.nl>
	 <20100303164306.451251096@chello.nl>
	 <bd4cb8901003031357x9c13c96h3899ab0459a34b0e@mail.gmail.com>
	 <1267693107.25158.149.camel@laptop>
	 <bd4cb8901003040954n5b05e139wa24f8e50789421ac@mail.gmail.com>
	 <1267726733.25158.219.camel@laptop>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 04 Mar 2010 21:23:25 +0100
Message-ID: <1267734205.16716.4.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 19:18 +0100, Peter Zijlstra wrote:
> What is currently implemented is that we loose history at the point a
> new task schedules in an LBR using event.
> 
This also matches CPU errata AX14, AJ52 and AAK109 which states that a
task switch may produce faulty LBR state, so clearing history after a
task switch seems the best thing to do.

