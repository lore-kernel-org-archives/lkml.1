Return-Path: <linux-kernel-owner+w=401wt.eu-S932088AbZJBKTP@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932088AbZJBKTP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Oct 2009 06:19:15 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756894AbZJBKTO
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 2 Oct 2009 06:19:14 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:33277 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756878AbZJBKTN convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com;2:1>);
	Fri, 2 Oct 2009 06:19:13 -0400
Message-Id: <4AC5EFC50200007800017ABC@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 02 Oct 2009 11:19:17 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: <adaplas@gmail.com>, <ilya.yanok@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Subject: commit 68e5e9d734503695915734e50e9427624cf8f3b2 (Re: vfb: make
	 virtual framebuffer mmapable)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any particular reason why this change uses vmalloc_32()
rather than simply vmalloc()? I can't see why the underlying physical
address width would matter here in any way...

Thanks, Jan

