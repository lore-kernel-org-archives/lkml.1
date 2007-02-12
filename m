Return-Path: <linux-kernel-owner+w=401wt.eu-S1030465AbXBLXIN@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030465AbXBLXIN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Feb 2007 18:08:13 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1030464AbXBLXIN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 12 Feb 2007 18:08:13 -0500
Received: from watts.utsl.gen.nz ([202.78.240.73]:36871 "EHLO
	magnus.utsl.gen.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030465AbXBLXIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Feb 2007 18:08:11 -0500
X-Greylist: delayed 1773 seconds by postgrey-1.27 at vger.kernel.org; Mon, 12 Feb 2007 18:08:11 EST
Message-ID: <45D0EC68.9090009@vilain.net>
Date: Tue, 13 Feb 2007 11:38:32 +1300
From: Sam Vilain <sam@vilain.net>
User-Agent: Thunderbird 1.5.0.2 (X11/20060521)
MIME-Version: 1.0
To: menage@google.com
Cc: akpm@osdl.org, pj@sgi.com, sekharan@us.ibm.com, dev@sw.ru, xemul@sw.ru,
       serue@us.ibm.com, vatsa@in.ibm.com, ebiederm@xmission.com,
       containers@lists.osdl.org, winget@google.com, rohitseth@google.com,
       ckrm-tech@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/7] containers (V7): Generic Process Containers
References: <20070212081521.808338000@menage.corp.google.com>
In-Reply-To: <20070212081521.808338000@menage.corp.google.com>
X-Enigmail-Version: 0.94.0.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

menage@google.com wrote:
> Generic Process Containers
> --------------------------
>
> There have recently been various proposals floating around for
> resource management/accounting and other task grouping subsystems in
> the kernel, including ResGroups, User BeanCounters, NSProxy
> containers, and others.  These all need the basic abstraction of being
> able to group together multiple processes in an aggregate, in order to
> track/limit the resources permitted to those processes, or control
> other behaviour of the processes, and all implement this grouping in
> different ways.
>   

I know I'm a bit out of touch, but AIUI the NSProxy *is* the container. 
We decided a long time ago that a container was basically just a set of
namespaces, which includes all of the subsystems you mention.

This would suggesting re-write this patchset, part 2 as a "CPUSet
namespace", part 4 as a "CPU scheduling namespace", parts 5 and 6 as
"Resource Limits Namespace" (drop this "BeanCounter" brand), and of
course part 7 falls away.

Sam.
