Return-Path: <linux-kernel-owner+w=401wt.eu-S1760291AbZCTS7U@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760291AbZCTS7U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Mar 2009 14:59:20 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751898AbZCTS7I
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 20 Mar 2009 14:59:08 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:56282 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754503AbZCTS7H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Mar 2009 14:59:07 -0400
Date: Fri, 20 Mar 2009 19:58:51 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Li Yang <leoli@freescale.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: nonboot cpu on SMP suspend
Message-ID: <20090320185851.GB1418@ucw.cz>
References: <2a27d3730903172325w16ec329cp872ec35d100f6506@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2a27d3730903172325w16ec329cp872ec35d100f6506@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2009-03-18 14:25:32, Li Yang wrote:
> Hi all,
> 
> I'm curious why we need to un-plug all the nonboot cpus before suspend
> and start them all over again after the suspend(ACPI sleep)?  I mean
> if we can bring the booting cpu back to the exact state as before
> suspend, why can't we just do the same for non-booting cpus?  And that
> will be much faster.  Any thought?  Thanks.

Why do you think it will be faster?
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
