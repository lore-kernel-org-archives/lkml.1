Return-Path: <linux-kernel-owner+w=401wt.eu-S1754827AbYIYP44@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827AbYIYP44 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 11:56:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753429AbYIYP4h
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 11:56:37 -0400
Received: from ug-out-1314.google.com ([66.249.92.173]:17422 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753196AbYIYP4e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 11:56:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=RZBIOfz0UQgMNFxxK5zi7Oe1vBIRgGaE64O/16rmZdYxN57QEQaeKRFqJQ/VY5dT0n
         N8Dh1SeciwGTnVxG2TuwZDyA+YEXDuVz+ztl4wSNQY+XpfTz/0vTGPROCViwW4XRgWPl
         vUZIuYIYggURxYalftZ5fmCdG/QUsrxJDF1E0=
Message-ID: <c62985530809250856l2c4e827cv2123b6c3c21210d7@mail.gmail.com>
Date: Thu, 25 Sep 2008 17:56:32 +0200
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Pekka Paalanen" <pq@iki.fi>
Subject: Re: [Patch -tip 1/3] Tracing/ftrace: Relay unhandled entry output
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
In-Reply-To: <20080925184919.016d8957@daedalus.pq.iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <48DB81BA.2050204@gmail.com> <20080925123802.GA6900@elte.hu>
	 <48DBA683.8000708@gmail.com>
	 <20080925180916.75d3c9ec@daedalus.pq.iki.fi>
	 <c62985530809250833x2468f07an547a82eaa1329d9@mail.gmail.com>
	 <20080925184919.016d8957@daedalus.pq.iki.fi>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/9/25 Pekka Paalanen <pq@iki.fi>:
> My understanding is that the pipe will be broken only, if the trace
> framework believes tracing is disabled. Recall the discussion about
> tracer_enabled = 0. Which is a bug, and I hoped Steven would have
> commented on how to fix that properly.
>
> Or was it fixed already, and this is a different issue?
> I didn't notice.

Actually there was two bugs which broke the pipe:
_ As you say the old one when none tracer put tracer_enabled = 0
_ And the new one I described here.

I think the first is fixed since none tracer has been replaced by "nop
tracer" (a recently implemented) which doesn't touch
tracer_enabled at all.
