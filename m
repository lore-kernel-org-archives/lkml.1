Return-Path: <linux-kernel-owner+w=401wt.eu-S1755752AbYIYQCS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755752AbYIYQCS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2008 12:02:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753765AbYIYQB6
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 25 Sep 2008 12:01:58 -0400
Received: from qb-out-0506.google.com ([72.14.204.239]:32965 "EHLO
	qb-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbYIYQB5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2008 12:01:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:in-reply-to:references:x-mailer
         :mime-version:content-type:content-transfer-encoding:sender;
        b=q+HmST03RgpZez6D5iY6SJAPs+9XmytcVG59SHUbk9BI/k83D5lzl8lpOdCx8sDRna
         BjffsQKnFQF+1EMAoBOBaH/ym+j5z+T62J3VX/U2zn6SkjimFsYKsy4wblxQhzbpJRf7
         bPwMZq1wZHFmMtvbEZx1yDCr4M5oMcGJdWW8A=
Date: Thu, 25 Sep 2008 19:01:49 +0300
From: Pekka Paalanen <pq@iki.fi>
To: "=?ISO-8859-1?Q?Fr=E9d=E9ric?= Weisbecker" <fweisbec@gmail.com>
Cc: "Steven Rostedt" <rostedt@goodmis.org>, "Ingo Molnar" <mingo@elte.hu>,
       linux-kernel@vger.kernel.org
Subject: Re: [Patch -tip 1/3] Tracing/ftrace: Relay unhandled entry output
Message-ID: <20080925190149.208ee3a4@daedalus.pq.iki.fi>
In-Reply-To: <c62985530809250856l2c4e827cv2123b6c3c21210d7@mail.gmail.com>
References: <48DB81BA.2050204@gmail.com>
	<20080925123802.GA6900@elte.hu>
	<48DBA683.8000708@gmail.com>
	<20080925180916.75d3c9ec@daedalus.pq.iki.fi>
	<c62985530809250833x2468f07an547a82eaa1329d9@mail.gmail.com>
	<20080925184919.016d8957@daedalus.pq.iki.fi>
	<c62985530809250856l2c4e827cv2123b6c3c21210d7@mail.gmail.com>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.12.11; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 25 Sep 2008 17:56:32 +0200
"Frédéric Weisbecker" <fweisbec@gmail.com> wrote:

> 2008/9/25 Pekka Paalanen <pq@iki.fi>:
> > My understanding is that the pipe will be broken only, if the trace
> > framework believes tracing is disabled. Recall the discussion about
> > tracer_enabled = 0. Which is a bug, and I hoped Steven would have
> > commented on how to fix that properly.
> >
> > Or was it fixed already, and this is a different issue?
> > I didn't notice.
> 
> Actually there was two bugs which broke the pipe:
> _ As you say the old one when none tracer put tracer_enabled = 0
> _ And the new one I described here.
> 
> I think the first is fixed since none tracer has been replaced by "nop
> tracer" (a recently implemented) which doesn't touch
> tracer_enabled at all.

Oh cool, sounds like I should try linux-next when I can.

-- 
Pekka Paalanen
http://www.iki.fi/pq/
