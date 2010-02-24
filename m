Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571Ab0BXKi0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Feb 2010 05:38:26 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.32]:54233 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756495Ab0BXKiZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Feb 2010 05:38:25 -0500
Message-ID: <4B85019E.9040708@ladisch.de>
Date: Wed, 24 Feb 2010 11:38:22 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Thunderbird 2.0.0.23 (Windows/20090812)
MIME-Version: 1.0
To: Theodore Tso <tytso@MIT.EDU>
CC: viresh kumar <viresh.linux@gmail.com>,
       Borislav Petkov <petkovbb@googlemail.com>, linux-kernel@vger.kernel.org
Subject: Re: QUERY: Inclusion of header files in kernel header files
References: <22dbbef21002222241h711402f1me6b60ac7502cccd4@mail.gmail.com> <22dbbef21002222243s7afb8e2cy1c783a29fe22ac55@mail.gmail.com> <20100223065953.GB32503@liondog.tnic> <22dbbef21002222331o6a59dc25mea3fc7e62dae6710@mail.gmail.com> <20100223095025.GA18559@liondog.tnic> <22dbbef21002230337i104c63dcm5d59064ca48a07f0@mail.gmail.com> <07BBC9AE-C1A1-449F-AE5E-EB5B1C6323C2@mit.edu>
In-Reply-To: <07BBC9AE-C1A1-449F-AE5E-EB5B1C6323C2@mit.edu>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Df-Sender: linux-kernel@cl.domainfactory-kunde.de
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Theodore Tso wrote:
> Also, it's highly desirable that as much as possible multiple
> inclusion is fixed up at the same time you add extra #includes into
> header files.   Protecting against multiple inclusion is critical,
> yes, but even with the protection against multiple inclusion, the
> header file has to get parsed a second time, and that slows down
> kernel compiles.

Multiple inclusion of a protected header does not hurt at all; gcc
detects that a header file uses #ifdef/#endif header guards and
automatically ignores any #include for that file if the symbol is
already defined.


Regards,
Clemens
