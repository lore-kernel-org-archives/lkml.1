Return-Path: <linux-kernel-owner+w=401wt.eu-S934561AbZKYEz0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934561AbZKYEz0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Nov 2009 23:55:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S934548AbZKYEzZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 24 Nov 2009 23:55:25 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:34631 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934545AbZKYEzY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Nov 2009 23:55:24 -0500
Subject: Re: cannot compile linux-2.6-tip tree
From: Steven Rostedt <rostedt@goodmis.org>
Reply-To: rostedt@goodmis.org
To: Bernd Petrovitsch <bernd@firmix.at>
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       fweisbec@gmail.com, linux-kernel@vger.kernel.org
In-Reply-To: <1259101632.6188.6.camel@gimli.petrovitsch.priv.at>
References: <20091124124107.GA1975@jolsa.lab.eng.brq.redhat.com>
	 <20091124154511.GG21821@elte.hu>
	 <20091124172208.GG1975@jolsa.lab.eng.brq.redhat.com>
	 <1259101632.6188.6.camel@gimli.petrovitsch.priv.at>
Content-Type: text/plain
Organization: Kihon Technologies Inc.
Date: Tue, 24 Nov 2009 23:55:29 -0500
Message-Id: <1259124929.22249.1133.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.26.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2009-11-24 at 23:27 +0100, Bernd Petrovitsch wrote:
> On Die, 2009-11-24 at 18:22 +0100, Jiri Olsa wrote: 
> > On Tue, Nov 24, 2009 at 04:45:11PM +0100, Ingo Molnar wrote:
> [...] 
> > > It's rare but happens. 'make clean' will cure that.
> Apart from disk full, hitting quota limits may give similar errors.

Yeah, the box I tested your config on filled up before finishing. But it
made it to the linking of the vmlinux before it died.

I did a:

 $ cd linux.git
 $ git checkout 2e7c0e0cafee # what you showed was the problem
 $ mkdir ../tmp
 $ cp ~/olsa-config ../tmp/.config
 $ make O=../tmp


When it died, tmp was 7964.05 MB in size!

-- Steve


