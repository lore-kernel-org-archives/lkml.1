Return-Path: <linux-kernel-owner+w=401wt.eu-S1756921AbXI2B7e@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921AbXI2B7e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2007 21:59:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753438AbXI2B7W
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 28 Sep 2007 21:59:22 -0400
Received: from phunq.net ([64.81.85.152]:34073 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754202AbXI2B7T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2007 21:59:19 -0400
From: Daniel Phillips <phillips@phunq.net>
To: "Daniel =?iso-8859-1?q?Sp=E5ng?=" <daniel.spang@gmail.com>
Subject: Re: Out of memory management in embedded systems
Date: Fri, 28 Sep 2007 18:59:18 -0700
User-Agent: KMail/1.9.5
Cc: linux-kernel@vger.kernel.org
References: <cfd9edbf0709280555n51afa8aft5040331ae9c227fd@mail.gmail.com>
In-Reply-To: <cfd9edbf0709280555n51afa8aft5040331ae9c227fd@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Message-Id: <200709281859.18275.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 28 September 2007 05:55, Daniel Spång wrote:
> Applications with dynamic input and dynamic memory usage have some
> issues with the current overcommitting kernel. A high memory usage
> situation eventually results in that a process is killed by the OOM
> killer. This is especially evident in swapless embedded systems with
> limited memory and no swap available.

In order to earn the right to fix this problem by inventing new Linux, 
first you need to post a traceback and a cat of /proc/meminfo to prove 
the OOM is a true one, as opposed to a second order effect of a 
writeout lockup.

Regards,

Daniel
