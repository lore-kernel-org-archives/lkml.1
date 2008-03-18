Return-Path: <linux-kernel-owner+w=401wt.eu-S966347AbYCTAXu@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966347AbYCTAXu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Mar 2008 20:23:50 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932693AbYCSXgN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 19 Mar 2008 19:36:13 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:50604 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764968AbYCSXgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Mar 2008 19:36:07 -0400
To: peterz@infradead.org
CC: miklos@szeredi.hu, akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
In-reply-to: <1205848760.8514.366.camel@twins> (message from Peter Zijlstra on
	Tue, 18 Mar 2008 14:59:20 +0100)
Subject: Re: [patch 4/8] mm: allow not updating BDI stats in
	end_page_writeback()
References: <20080317191908.123631326@szeredi.hu>
	 <20080317191945.122011759@szeredi.hu> <1205840031.8514.346.camel@twins>
	 <E1JbaTH-0005jN-4r@pomaz-ex.szeredi.hu> <1205843375.8514.357.camel@twins>
	 <E1JbbHf-0005rm-R5@pomaz-ex.szeredi.hu> <1205845702.8514.365.camel@twins>
	 <E1JbcKL-00060V-9N@pomaz-ex.szeredi.hu> <1205848760.8514.366.camel@twins>
Message-Id: <E1Jbe8O-0006H7-E4@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Tue, 18 Mar 2008 16:53:52 +0100
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > Well, but this is the kernel, you can't really make foolproof
> > interfaces.  If we'll go with Andrew's suggestion, I'll add comments
> > warning users about not touching those flags unless they know what
> > they are doing, OK?
> 
> Yeah, I guess so :-)

Cool :)

On a related note, is there a reason why bdi_cap_writeback_dirty() and
friends need to be macros instead of inline functions?  If not I'd
clean that up as well.

Miklos
