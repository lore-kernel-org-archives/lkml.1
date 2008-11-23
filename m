Return-Path: <linux-kernel-owner+w=401wt.eu-S1757667AbYKWDVp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667AbYKWDVp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Nov 2008 22:21:45 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755411AbYKWDVf
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 22 Nov 2008 22:21:35 -0500
Received: from wf-out-1314.google.com ([209.85.200.175]:64428 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751786AbYKWDVe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Nov 2008 22:21:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=e2VvlSj/UdkyP5w6dWddKHbsItod4J11joQr9el4xU8yrVZryHkx3tSsHz3joC+Ar6
         Z94PY1xqdYOykNUFZcuNJCa3l9+g4SUFdUSABSoB+XxC6RDwurv6Br3WjtiA53LHENwX
         p+zzRU7abfkPs4CyybaXhuEUonZ/0Zw3Cdz24=
Subject: Re: [PATCH] UBIFS: endian handling fixes and annotations
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Sebastian Andrzej Siewior <sebastian@breakpoint.cc>
Cc: Artem Bityutskiy <dedekind@infradead.org>, linux-fsdevel@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20081122192747.GB21433@Chamillionaire.breakpoint.cc>
References: <1227287970-14684-1-git-send-email-dedekind@infradead.org>
	 <1227287970-14684-3-git-send-email-dedekind@infradead.org>
	 <20081122192747.GB21433@Chamillionaire.breakpoint.cc>
Content-Type: text/plain
Date: Sat, 22 Nov 2008 19:21:29 -0800
Message-Id: <1227410489.6117.1.camel@brick>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2008-11-22 at 20:27 +0100, Sebastian Andrzej Siewior wrote:
> * Artem Bityutskiy | 2008-11-21 19:19:24 [+0200]:
> 
> > 	save_flags = mst->flags;
> >-	mst->flags = cpu_to_le32(le32_to_cpu(mst->flags) | UBIFS_MST_RCVRY);
> >+	mst->flags |= cpu_to_le32(UBIFS_MST_RCVRY);
> 
> another micro optimisation would be to use __constant_cpu_to_le32()
> 

Nope, no difference, cpu_to_le32 does constant-detection these days and
so there ends up being no difference.

Harvey

