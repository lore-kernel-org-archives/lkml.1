Return-Path: <linux-kernel-owner+w=401wt.eu-S1760954AbYCWLZm@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760954AbYCWLZm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Mar 2008 07:25:42 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755785AbYCWLZc
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 23 Mar 2008 07:25:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:38496 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755825AbYCWLZc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Mar 2008 07:25:32 -0400
Date: Sun, 23 Mar 2008 12:28:29 +0100
From: Andi Kleen <andi@firstfloor.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org, pj@sgi.com,
       linux-mm@kvack.org, nickpiggin@yahoo.com.au
Subject: Re: [PATCH] [2/18] Add basic support for more than one hstate in hugetlbfs
Message-ID: <20080323112829.GA1619@one.firstfloor.org>
References: <20080317258.659191058@firstfloor.org> <20080317015815.D43991B41E0@basil.firstfloor.org> <20080323193340.B31D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080323193340.B31D.KOSAKI.MOTOHIRO@jp.fujitsu.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> this function is called once by one boot parameter, right?
> if so, this function cause panic when stupid user write many 
> hugepagesz boot parameter.

A later patch fixes that up by looking up the hstate explicitely. Also it 
is bisect safe because the callers are only added later.

-Andi
