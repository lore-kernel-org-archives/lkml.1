Return-Path: <linux-kernel-owner+w=401wt.eu-S1759832AbZDXOCf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759832AbZDXOCf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Apr 2009 10:02:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755281AbZDXOC1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 24 Apr 2009 10:02:27 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:48135 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754799AbZDXOC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Apr 2009 10:02:26 -0400
Date: Fri, 24 Apr 2009 15:02:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Alessio Igor Bogani <abogani@texware.it>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Suggestions request for speed-up kernel compilation
Message-ID: <20090424140226.GK8633@ZenIV.linux.org.uk>
References: <63a49ef40904240257w45cc9c03n6e71ff4e4f69209b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <63a49ef40904240257w45cc9c03n6e71ff4e4f69209b@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 24, 2009 at 11:57:35AM +0200, Alessio Igor Bogani wrote:
> Hi All,
> 
> Sorry for my bad English.
> 
> I'm a kernel newbie and I would be very happy to receive some tips
> about kernel compilation from experienced developers.
> 
> I have recently elaborated some trivial patches. For each one I have
> done a build test at minimum and I find myself spend a lot of time
> waiting my Core Duo to accomplish this task. Make is a very smart tool
> but after a git pull or a git fetch origin/git reset --hard origin it
> can't help as desired.

ccache, for normal times, as suggested in other reply.  But if you or
mainline or something you've pulled change the headers, there's not much
to be done, unfortunately...
