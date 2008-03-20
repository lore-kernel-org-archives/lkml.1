Return-Path: <linux-kernel-owner+w=401wt.eu-S1754705AbYCTIKo@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754705AbYCTIKo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2008 04:10:44 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752468AbYCTIKd
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 20 Mar 2008 04:10:33 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:57633 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752415AbYCTIKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2008 04:10:32 -0400
Date: Thu, 20 Mar 2008 04:10:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Christoph Hellwig <hch@infradead.org>,
       Romano Giannetti <romanol@upcomillas.es>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc1/2 regression: first-time login into gnome fails
Message-ID: <20080320081028.GA27854@infradead.org>
References: <1203332161.26696.11.camel@pern> <2c0942db0802180815r59c2ef1s8d4c2e1e733b79c4@mail.gmail.com> <20080317120641.GA16710@infradead.org> <2c0942db0803170847n3e88bdf6r33eabe4c15e7d3f2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0803170847n3e88bdf6r33eabe4c15e7d3f2@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 17, 2008 at 08:47:30AM -0700, Ray Lee wrote:
> I'm assuming you upgraded from 2.6.24, correct? (not .25-rcX).

Yes.

> Are you running either debian or ubuntu?

Yes.

> If so, do you have the
> dbus-x11 package installed? Alternately, does /usr/bin/dbus-launch
> exist? If no, try installing dbus-x11 and try again. I think a
> side-effect of installing is to start dbus earlier, and may perhaps
> avoid the race (if it is a race that's causing all this, which I still
> think it is).

Yes, installing dbus-x11 makes everything work properly, aka paper
over the underlying issue.

