Return-Path: <linux-kernel-owner+w=401wt.eu-S1755088AbYAOI6T@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755088AbYAOI6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2008 03:58:19 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752074AbYAOI6J
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 15 Jan 2008 03:58:09 -0500
Received: from pentafluge.infradead.org ([213.146.154.40]:37206 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751425AbYAOI6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2008 03:58:08 -0500
Subject: Re: [RFC] mmaped copy too slow?
From: Peter Zijlstra <peterz@infradead.org>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Rik van Riel <riel@redhat.com>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20080115115318.1191.KOSAKI.MOTOHIRO@jp.fujitsu.com>
References: <20080115100450.1180.KOSAKI.MOTOHIRO@jp.fujitsu.com>
	 <20080114211540.284df4fb@bree.surriel.com>
	 <20080115115318.1191.KOSAKI.MOTOHIRO@jp.fujitsu.com>
Content-Type: text/plain
Date: Tue, 15 Jan 2008 09:57:58 +0100
Message-Id: <1200387478.15103.21.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.21.4 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Tue, 2008-01-15 at 12:20 +0900, KOSAKI Motohiro wrote:
> Hi Rik
> 
> > While being able to deal with used-once mappings in page reclaim
> > could be a good idea, this would require us to be able to determine
> > the difference between a page that was accessed once since it was
> > faulted in and a page that got accessed several times.
> 
> it makes sense that read ahead hit assume used-once mapping, may be.
> I will try it.

I once had a patch that made read-ahead give feedback into page reclaim,
but people didn't like it.

