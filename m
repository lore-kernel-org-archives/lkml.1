Return-Path: <linux-kernel-owner+w=401wt.eu-S1754149AbYJXORT@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149AbYJXORT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Oct 2008 10:17:19 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752616AbYJXORJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Oct 2008 10:17:09 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:49021 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751719AbYJXORJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Oct 2008 10:17:09 -0400
Subject: Re: [PROBLEM] hard-lock with kmemtrace, relayfs, and splice
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Peter Teoh <htmldeveloper@gmail.com>
Cc: Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
       zanussi@comcast.net, jens.axboe@oracle.com,
       linux-kernel@vger.kernel.org
In-Reply-To: <804dabb00810232144w4a618737l28c1d63108594d1e@mail.gmail.com>
References: <20080923212914.GB5237@localhost>
	 <1223386477.28348.42.camel@penberg-laptop>
	 <1223623191.8959.26.camel@penberg-laptop>
	 <1223628687.8959.37.camel@penberg-laptop>
	 <1223629803.8959.40.camel@penberg-laptop>
	 <1223631723.8959.46.camel@penberg-laptop>
	 <804dabb00810232144w4a618737l28c1d63108594d1e@mail.gmail.com>
Date: Fri, 24 Oct 2008 17:15:56 +0300
Message-Id: <1224857756.5519.5.camel@penberg-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
X-Mailer: Evolution 2.22.3.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2008-10-24 at 12:44 +0800, Peter Teoh wrote:
> after doing a
> 
> git clone git://repo.or.cz/linux-2.6/kmemtrace.git
> 
> I reboot the OS and encountered several application crashes.....the
> logs are as per attached....please comment.
> 
> for bug0 and bug1, the system go into a state of complete
> non-responsive, even connecting via SSH into the system becomes
> impossible, and bug0 and bug1 was generated just before it goes into
> this state.
> 
> for bug2, the mouse seemed to respond, i managed to output the dmesg
> (which is bug2 itself).
> 
> any comments?

Hmm, you're hitting out-of-memory. I can't immediately see how kmemtrace
is at fault here. Eduard, thoughts?

