Return-Path: <linux-kernel-owner+w=401wt.eu-S1030237AbXCFSsp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030237AbXCFSsp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2007 13:48:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030231AbXCFSsp
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 6 Mar 2007 13:48:45 -0500
Received: from mx1.redhat.com ([66.187.233.31]:41319 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030237AbXCFSso (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2007 13:48:44 -0500
From: David Howells <dhowells@redhat.com>
In-Reply-To: <45EDB568.1090008@zytor.com> 
References: <45EDB568.1090008@zytor.com>  <20070306183426.10768.51800.stgit@warthog.cambridge.redhat.com> 
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: torvalds@osdl.org, akpm@osdl.org, benh@kernel.crashing.org,
       linux-kernel@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: [PATCH] Fix get_order() [try #2] 
X-Mailer: MH-E 8.0; nmh 1.1; GNU Emacs 22.0.50
Date: Tue, 06 Mar 2007 18:47:46 +0000
Message-ID: <11476.1173206866@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

H. Peter Anvin <hpa@zytor.com> wrote:

> Why not just make it ((n) < 1 ? 0 : ...) and make it well-defined for
> n == 0?

Because log2(0) is -INF or mathematically undefined or something isn't it?

David
