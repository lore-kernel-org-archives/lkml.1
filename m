Return-Path: <linux-kernel-owner+w=401wt.eu-S1755222AbZFWVKO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbZFWVKO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jun 2009 17:10:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753857AbZFWVKD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 23 Jun 2009 17:10:03 -0400
Received: from pfepa.post.tele.dk ([195.41.46.235]:45949 "EHLO
	pfepa.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753469AbZFWVKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jun 2009 17:10:03 -0400
Date: Tue, 23 Jun 2009 23:12:22 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Jesper Nilsson <Jesper.Nilsson@axis.com>
Cc: Tim Abbott <tabbott@MIT.EDU>,
       Linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Anders Kaseorg <andersk@MIT.EDU>, Waseem Daher <wdaher@MIT.EDU>,
       Denys Vlasenko <vda.linux@googlemail.com>,
       Jeff Arnold <jbarnold@MIT.EDU>,
       Mikael Starvik <mikael.starvik@axis.com>
Subject: Re: [PATCH] cris: use new macros for .data.init_task.
Message-ID: <20090623211222.GB24201@uranus.ravnborg.org>
References: <1241135077-8001-1-git-send-email-tabbott@mit.edu> <1241135077-8001-2-git-send-email-tabbott@mit.edu> <20090623090614.GZ12383@axis.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090623090614.GZ12383@axis.com>
User-Agent: Mutt/1.4.2.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 23, 2009 at 11:06:14AM +0200, Jesper Nilsson wrote:
> On Fri, May 01, 2009 at 01:44:37AM +0200, Tim Abbott wrote:
> > .data.init_task should not need a separate output section; this change
> > moves it into the .data section.
> 
> Hi,
> 
> Sorry about not picking this up earlier, but what's the status of
> the prerequisite macros? From what I can see, the prerequisite for
> the first part of the patch is now in mainline, but there seems to
> be no users of INIT_TASK_DATA yet.
> (And it looks a bit dodgy as it uses INIT_TASK without any argument...)
I applied that patch already.


I have concentrated on the vmlinux.lds stuff.
And I hope Tim will look into the rest once more.

Tim - any news from your side?

	Sam
