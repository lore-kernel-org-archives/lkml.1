Return-Path: <linux-kernel-owner+w=401wt.eu-S1752671AbZEYOVj@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbZEYOVj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 May 2009 10:21:39 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751747AbZEYOVb
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 25 May 2009 10:21:31 -0400
Received: from hera.kernel.org ([140.211.167.34]:40136 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751732AbZEYOVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 May 2009 10:21:30 -0400
Subject: Re: [lm-sensors] [PATCH-tip] x86: hwmon/k8temp.c Add support for 
 AMD 10H and 11H
From: Jaswinder Singh Rajput <jaswinder@kernel.org>
To: Jean Delvare <khali@linux-fr.org>
Cc: Rudolf Marek <r.marek@assembler.cz>, Ingo Molnar <mingo@elte.hu>,
       x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
       LM Sensors <lm-sensors@lm-sensors.org>
In-Reply-To: <20090525154501.3f251a23@hyperion.delvare>
References: <1242979484.8796.7.camel@localhost.localdomain>
	 <4A165F67.3020005@assembler.cz>
	 <1242981748.10642.3.camel@localhost.localdomain>
	 <1242984648.16532.3.camel@localhost.localdomain>
	 <20090525154501.3f251a23@hyperion.delvare>
Content-Type: text/plain
Date: Mon, 25 May 2009 19:47:19 +0530
Message-Id: <1243261039.3098.5.camel@localhost.localdomain>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-1.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jean,

On Mon, 2009-05-25 at 15:45 +0200, Jean Delvare wrote:
> Hi Jaswinder,
> 
> On Fri, 22 May 2009 15:00:48 +0530, Jaswinder Singh Rajput wrote:
> > Atleast something is better than nothing ;-)
> 
> Sorry but you are wrong here. When it comes to hardware monitoring (or
> monitoring in general), potentially wrong data is _worse_ than no data
> at all, unless you additionally carry the information that the data
> value may be wrong, and display it in a very visible manner. As our
> sysfs interface doesn't provide any way to pass reliability information
> to the reader (and I don't think it would make sense to add one), it is
> better to not export data that we know can't be trusted.
> 

As I said in my previous email that it seems problem is with few 10H
cpus and 11H are OK.

So better we will fix wrong information or suppress information for
those specific cpus.

On my 11H laptop monitoring seems very reliable. So in the worst case we
drop support for 10H.

Thanks,
--
JSR



