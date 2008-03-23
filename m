Return-Path: <linux-kernel-owner+w=401wt.eu-S1761286AbYCWLaY@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761286AbYCWLaY (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 07:30:24 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755479AbYCWLaN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 07:30:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:55591 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbYCWLaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 07:30:12 -0400
Date: Sun, 23 Mar 2008 20:30:31 +0900
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Subject: Re: [PATCH] [2/18] Add basic support for more than one hstate in hugetlbfs
Cc: kosaki.motohiro@jp.fujitsu.com, linux-kernel@vger.kernel.org, pj@sgi.com,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
In-Reply-To: <20080323112829.GA1619@one.firstfloor.org>
References: <20080323193340.B31D.KOSAKI.MOTOHIRO@jp.fujitsu.com> <20080323112829.GA1619@one.firstfloor.org>
Message-Id: <20080323203010.B323.KOSAKI.MOTOHIRO@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.42 [ja]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > this function is called once by one boot parameter, right?
> > if so, this function cause panic when stupid user write many 
> > hugepagesz boot parameter.
> 
> A later patch fixes that up by looking up the hstate explicitely. Also it 
> is bisect safe because the callers are only added later.

Oops, sorry.


