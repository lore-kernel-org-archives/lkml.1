Return-Path: <linux-kernel-owner+w=401wt.eu-S1752156AbZIZKbZ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156AbZIZKbZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Sep 2009 06:31:25 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752037AbZIZKbZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 26 Sep 2009 06:31:25 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:36277 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752036AbZIZKbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Sep 2009 06:31:24 -0400
Subject: Re: [GIT PULL v2] bkl tracepoints + filter regex support
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
       LKML <linux-kernel@vger.kernel.org>, Tom Zanussi <tzanussi@gmail.com>,
       Li Zefan <lizf@cn.fujitsu.com>
In-Reply-To: <1253871601.10287.23.camel@twins>
References: <1253821775-8618-1-git-send-email-fweisbec@gmail.com>
	 <20090924201509.GA26573@elte.hu> <20090924201622.GA15459@elte.hu>
	 <1253824200.18939.173.camel@laptop> <20090924204357.GB8662@nowhere>
	 <1253825489.18939.180.camel@laptop> <20090924213631.GA2661@nowhere>
	 <1253866792.10287.0.camel@twins>  <20090925091229.GB4686@nowhere>
	 <1253871601.10287.23.camel@twins>
Content-Type: text/plain
Date: Sat, 26 Sep 2009 06:30:15 -0400
Message-Id: <1253961015.12145.120.camel@frodo>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 (2.26.3-1.fc11) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2009-09-25 at 11:40 +0200, Peter Zijlstra wrote:

> Using globs in string matches most certainly is useful, no question
> about that.
> 
> But I had understood from previous communications we were going to have
> a C syntax, and there == is a straight comparison.
> 
> If however people have changed their minds (fine with me) and we're now
> going to script like things..
> 
> Anyway, a glob in == just means we have to use another operator if we
> ever want to support actual regexes, ~ would then be recommened I think,
> since that's what awk and I think perl do.

I agree that any use of '==' should be a direct match and if you want to
add a glob expression you can use something else. Like what Peter showed
(~) or even better =~ which is what perl uses.

/me runs

;-)

-- Steve

> 
> Personally I wouldn't mind things like:
> 
>  glob_match(string, pattern)
>  regex_match(string, pattern)
> 
> But everybody involved in this filter stuff needs to agree what
> direction you want to take the language in.


