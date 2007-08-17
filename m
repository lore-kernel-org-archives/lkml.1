Return-Path: <linux-kernel-owner+w=401wt.eu-S1757511AbXHQEXl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757511AbXHQEXl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2007 00:23:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752986AbXHQEXd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 17 Aug 2007 00:23:33 -0400
Received: from pentafluge.infradead.org ([213.146.154.40]:33250 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752916AbXHQEXd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2007 00:23:33 -0400
Date: Fri, 17 Aug 2007 10:06:20 +0530 (IST)
From: Satyam Sharma <satyam@infradead.org>
X-X-Sender: satyam@enigma.security.iitk.ac.in
To: David Schwartz <davids@webmaster.com>
cc: "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 0/24] make atomic_read() behave consistently across all
 architectures
In-Reply-To: <MDEHLPKNGKAHNMBLJOLKOEJBGDAC.davids@webmaster.com>
Message-ID: <alpine.LFD.0.999.0708171002410.3666@enigma.security.iitk.ac.in>
References: <MDEHLPKNGKAHNMBLJOLKOEJBGDAC.davids@webmaster.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

[ Your mailer drops Cc: lists, munges headers,
  does all sorts of badness. Please fix that. ]


On Thu, 16 Aug 2007, David Schwartz wrote:

> 
> > There is a quite convincing argument that such an access _is_ an
> > access to a volatile object; see GCC PR21568 comment #9.  This
> > probably isn't the last word on the matter though...
> 
> I find this argument completely convincing and retract the contrary argument
> that I've made many times in this forum and others. You learn something new
> every day.
> 
> Just in case it wasn't clear:
> int i;
> *(volatile int *)&i=2;
> 
> In this case, there *is* an access to a volatile object. This is the end
> result of the the standard's definition of what it means to apply the
> 'volatile int *' cast to '&i' and then apply the '*' operator to the result
> and use it as an lvalue.

True, see my last mail in this sub-thread that explains precisely this :-)


Satyam
