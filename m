Return-Path: <linux-kernel-owner+w=401wt.eu-S1761269AbXEKRFv@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761269AbXEKRFv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 May 2007 13:05:51 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1759079AbXEKRFo
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 11 May 2007 13:05:44 -0400
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:55186 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754805AbXEKRFo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 May 2007 13:05:44 -0400
Date: Fri, 11 May 2007 10:05:44 -0700 (PDT)
From: Christoph Lameter <clameter@sgi.com>
X-X-Sender: clameter@schroedinger.engr.sgi.com
To: Bas Westerbaan <bas.westerbaan@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: Conveying memory pressure to userspace?
In-Reply-To: <6880bed30705101756nb5bd0c5s97935b97d07f846a@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0705111005200.32716@schroedinger.engr.sgi.com>
References: <6880bed30705101756nb5bd0c5s97935b97d07f846a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 11 May 2007, Bas Westerbaan wrote:

> These applications are unaware of memory pressure.  While the kernel
> is trying its best to to free memory by for instance dropping,
> possibly more valuable caches, userspace is left blissfully unaware.

cpusets export a notion of memory pressure to user space. See the cpusets 
documentation.
