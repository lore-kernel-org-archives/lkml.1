Return-Path: <linux-kernel-owner+w=401wt.eu-S1752007AbZLIInH@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752007AbZLIInH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Dec 2009 03:43:07 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751925AbZLIInG
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 9 Dec 2009 03:43:06 -0500
Received: from mail-ew0-f209.google.com ([209.85.219.209]:51214 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699AbZLIInF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Dec 2009 03:43:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=Jyz1TDr2WsX3XyUp+rVbRrYPTiQ5XhTuNs7VfQ85OUwHDlrekFrZhAStEDq6uuTTIv
         LeMYZwYQHPJ4au2ftU0cKNypAyopoaUzqw1PpbJMum2YEiCyRTjj2lXHzHQAzG0IURaS
         wsKvI8EhJVBrphv5o0aU8I43wiB1mfWeAvmxw=
Date: Wed, 9 Dec 2009 09:43:08 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <peterz@infradead.org>,
       Paul Mackerras <paulus@samba.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] perf_event: allocate children's perf_event_ctxp at
	the right time
Message-ID: <20091209084306.GB5152@nowhere>
References: <4B1F194D.7080306@cn.fujitsu.com> <4B1F19A8.5040805@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B1F19A8.5040805@cn.fujitsu.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 09, 2009 at 11:29:44AM +0800, Xiao Guangrong wrote:
> In current code, children task will allocate memory for
> 'child->perf_event_ctxp' if the parent is counted, we can
> do it only if the parent allowed children inherit it.
> 
> It can save memory and reduce overhead
> 
> Signed-off-by: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>



Reviewed-by: Frederic Weisbecker <fweisbec@gmail.com>

