Return-Path: <linux-kernel-owner+w=401wt.eu-S1762716AbYHDTve@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762716AbYHDTve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2008 15:51:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1758157AbYHDTv1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 4 Aug 2008 15:51:27 -0400
Received: from ns1.q-leap.de ([153.94.51.193]:36609 "EHLO mail.q-leap.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759054AbYHDTv1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2008 15:51:27 -0400
From: Bernd Schubert <bs@q-leap.de>
To: Robert Hancock <hancockr@shaw.ca>
Subject: Re: sysrq+t doesn't work for some threads
Date: Mon, 4 Aug 2008 21:51:24 +0200
User-Agent: KMail/1.9.9
Cc: linux-kernel@vger.kernel.org
References: <fa.sh1LseUiXeu++640VETUX2tdFMs@ifi.uio.no> <48975C96.9090401@shaw.ca>
In-Reply-To: <48975C96.9090401@shaw.ca>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200808042151.25342.bs@q-leap.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 04 August 2008 21:46:30 Robert Hancock wrote:
> Bernd Schubert wrote:
> > Hello,
> >
> > I need to debug a lustre problem, where lustre threads take 100% cpu time
> > and also have a memory leak. The problem is, that sysrq+t doesn't work
> > for these threads. It nicely shows all stack traces, just the trouble
> > some threads won't show their traces:
> >
> > [69338.858825] ll_mdt_36     R  running task       0 21679      2 (L-TLB)
>
> This means this task is running, you won't get a stack trace for such a
> thread. You'd likely have to stop it somehow. Is this a kernel thread?

Yes, it is a kernel thread. How can I stop it? Is there a way to stop kernel 
threads at all? kill -STOP doesn't work.


Thanks,
Bernd



-- 
Bernd Schubert
Q-Leap Networks GmbH
