Return-Path: <linux-kernel-owner+w=401wt.eu-S1754214AbYLSMF0@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754214AbYLSMF0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2008 07:05:26 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751828AbYLSMFN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Dec 2008 07:05:13 -0500
Received: from cassiel.sirena.org.uk ([80.68.93.111]:1862 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751355AbYLSMFL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2008 07:05:11 -0500
Date: Fri, 19 Dec 2008 12:05:07 +0000
From: Mark Brown <broonie@sirena.org.uk>
To: Jonathan Cameron <Jonathan.Cameron@gmail.com>
Cc: Balaji Rao <balajirrao@openmoko.org>, linux-kernel@vger.kernel.org,
       Andy Green <andy@openmoko.com>, Samuel Ortiz <sameo@openedhand.com>
Subject: Re: [PATCH V2 2/7] mfd: PCF50633 adc driver
Message-ID: <20081219120506.GJ24129@sirena.org.uk>
References: <20081218055618.31696.65002.stgit@cff.thadambail> <20081218055653.31696.4361.stgit@cff.thadambail> <494B831C.5050402@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <494B831C.5050402@gmail.com>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.13 (2006-08-11)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 19, 2008 at 11:18:52AM +0000, Jonathan Cameron wrote:

> Nice driver.  I particularly like the queueing structure. In the IIO
> design I hadn't come across any devices that operate in this request
> then wait for interrupt fashion.  May need to rethink a few bits of
> that.

There's auxiliary ADCs like that in several Wolfson parts too - at least
WM97xx and WM8350 have them.  They're typically used for applications
like battery and supply monitoring.
