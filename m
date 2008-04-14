Return-Path: <linux-kernel-owner+w=401wt.eu-S1757824AbYDNTQb@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757824AbYDNTQb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2008 15:16:31 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753633AbYDNTQV
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 14 Apr 2008 15:16:21 -0400
Received: from mx1.redhat.com ([66.187.233.31]:40774 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753584AbYDNTQU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2008 15:16:20 -0400
Message-ID: <4803AD83.4030807@redhat.com>
Date: Mon, 14 Apr 2008 15:16:19 -0400
From: Chris Snook <csnook@redhat.com>
User-Agent: Thunderbird 2.0.0.12 (X11/20080226)
MIME-Version: 1.0
To: Marc Perkel <mperkel@yahoo.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: AMD Quad Core clock problem?
References: <303918.65020.qm@web52503.mail.re2.yahoo.com>
In-Reply-To: <303918.65020.qm@web52503.mail.re2.yahoo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc Perkel wrote:
> My best guess at this time is that the drift of this
> computer using the quad core is so great that the ntpd
> can't get in sync. Is there any way to make ntpd more
> agressive by setting something in ntp.conf?

ntp can correct for 500 ppm drift, which equates to 1.8 seconds per hour. 
Beyond that you need to run ntpdate or ntpd -gq from cron to correct it.

-- Chris
