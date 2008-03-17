Return-Path: <linux-kernel-owner+w=401wt.eu-S1754549AbYCQMHB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754549AbYCQMHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2008 08:07:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751874AbYCQMGv
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 17 Mar 2008 08:06:51 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:55247 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753880AbYCQMGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2008 08:06:44 -0400
Date: Mon, 17 Mar 2008 08:06:42 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Ray Lee <ray-lk@madrabbit.org>
Cc: Romano Giannetti <romanol@upcomillas.es>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.25-rc1/2 regression: first-time login into gnome fails
Message-ID: <20080317120641.GA16710@infradead.org>
References: <1203332161.26696.11.camel@pern> <2c0942db0802180815r59c2ef1s8d4c2e1e733b79c4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2c0942db0802180815r59c2ef1s8d4c2e1e733b79c4@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 18, 2008 at 08:15:01AM -0800, Ray Lee wrote:
> It may be a race. Please try booting up, then waiting for a minute or
> two once you see the gdm login screen, then try logging in.
> 
> If that succeeds then something (dbus perhaps) is hanging on something
> that eventually times out.

Just upgraded my laptop to 2.6.25-rc6 and I see the same.  A little
instrumentation shows that there is no socket to connect to aka the
server side process (whatever that is) didn't start.

