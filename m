Return-Path: <linux-kernel-owner+w=401wt.eu-S1756102AbYJaAFl@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102AbYJaAFl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2008 20:05:41 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752541AbYJaAFd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Oct 2008 20:05:33 -0400
Received: from qw-out-2122.google.com ([74.125.92.26]:2849 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754209AbYJaAFc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2008 20:05:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references;
        b=lWlzx1vxIdshfeAcsM5KIpzV0HjCaa3CnRU/ry1iTVOUTMBiWAAovCfsjgLCkxbXkd
         y2FmfQ+83mx0dR5qauAJvpA5q8KRyaSNgZ/RDKzyzkq8VZku9DloehwCZ6p7Mc6UwO5y
         C90E9zIqZ3sCl1YCBsloTHqI++vL6DH55KGOU=
Message-ID: <c62985530810301705h356decf8oea0db02def2ab3c1@mail.gmail.com>
Date: Fri, 31 Oct 2008 01:05:30 +0100
From: "=?ISO-8859-1?Q?Fr=E9d=E9ric_Weisbecker?=" <fweisbec@gmail.com>
To: "Steven Rostedt" <rostedt@goodmis.org>
Subject: Re: [RFC][PATCH] Make ftrace able to trace function return
Cc: "Ingo Molnar" <mingo@elte.hu>, linux-kernel@vger.kernel.org
In-Reply-To: <alpine.DEB.1.10.0810301556010.19996@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <490A08E3.2040201@gmail.com>
	 <alpine.DEB.1.10.0810301556010.19996@gandalf.stny.rr.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2008/10/30 Steven Rostedt <rostedt@goodmis.org>:
> What about storing the return addresses on the bottom of the stack?
> That is, start at task->stack + sizeof(thread_info), and stack up on that.
> Be careful, there might already be users of that area. This will also need
> to be arch dependent.

But how could I assume there is enough space behind this address to store a long
stack of functions calls for a same thread?
And if an interrupt is raised, would a reference to "current task" be
really consistant?

I don't know much about the bottom stack of the tasks, I'm not sure
about how much
space I can use inside... I should study this field. Who could be the
potential users of this area?
