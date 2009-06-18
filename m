Return-Path: <linux-kernel-owner+w=401wt.eu-S1755633AbZFRDnR@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755633AbZFRDnR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Jun 2009 23:43:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752476AbZFRDnE
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 17 Jun 2009 23:43:04 -0400
Received: from vena.lwn.net ([206.168.112.25]:49952 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752113AbZFRDnD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Jun 2009 23:43:03 -0400
Date: Wed, 17 Jun 2009 21:43:03 -0600
From: Jake Edge <jake@lwn.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: problem with function_graph self-test?
Message-ID: <20090617214303.483fe0a0@chukar>
In-Reply-To: <alpine.DEB.2.00.0906172312450.6890@gandalf.stny.rr.com>
References: <20090616122603.6a628097@chukar>
	<alpine.DEB.2.00.0906172312450.6890@gandalf.stny.rr.com>
X-Mailer: Claws Mail 3.7.0 (GTK+ 2.14.7; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 17 Jun 2009 23:24:18 -0400 (EDT) Steven Rostedt wrote:

> Jake, when you find a bug, you really find a bug!

heh, glad to be of service :)

> This is something that gcc is screwing with us. After spending all
> day today trying to figure out what is happening, I finally found it
> in the assembly.

is there something specific to my config that causes this to happen?  I
assume other folks are running the function_graph selftest under other,
quite possibly more sane, configs without running into it ... or is it
just something that most folks aren't running (i can't remember why i
turned ftrace selftests on, other than, perhaps, general curiosity) ...

you don't run into this under your "normal" configs?

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
