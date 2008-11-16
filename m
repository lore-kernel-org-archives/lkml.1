Return-Path: <linux-kernel-owner+w=401wt.eu-S1754801AbYKPW1r@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754801AbYKPW1r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Nov 2008 17:27:47 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753513AbYKPW1e
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Nov 2008 17:27:34 -0500
Received: from 3a.49.1343.static.theplanet.com ([67.19.73.58]:58286 "EHLO
	pug.o-hand.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438AbYKPW1e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Nov 2008 17:27:34 -0500
Date: Sun, 16 Nov 2008 23:30:14 +0100
From: Samuel Ortiz <sameo@openedhand.com>
To: Mark Brown <broonie@sirena.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2.6.28] mfd: Correct WM8350 I2C return code usage
Message-ID: <20081116223013.GB2977@sortiz.org>
Reply-To: Samuel Ortiz <sameo@openedhand.com>
References: <1226324477-21022-1-git-send-email-broonie@opensource.wolfsonmicro.com> <20081112184956.GA17382@sortiz.org> <20081112200007.GA31451@sirena.org.uk> <20081112230636.GB17382@sortiz.org> <20081112234331.GB8272@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20081112234331.GB8272@sirena.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 12, 2008 at 11:43:31PM +0000, Mark Brown wrote:
> > With this patch you're breaking that expectation because the read|write_dev()
> > I'd prefer to fix the callers code, so that we keep the expected semantics
> 
> Just to clarify, when you say "expectation" and "fix" are you talking
> about your preference that the hardware access functions return the
> number of bytes read or written or is there something else going on
> here? 
No, definitely just my preference. I personnaly expect this kind of IO
routines to return the number of bytes read/written.

> To be honest I'm really not sure it's worth changing this - I'm having a
> hard time thinking of a user that would be able to do anything useful
> with a short access.  
I agree with that, yes.

> It also seems like it'd be a rather invasive
> change for an -rc.
Fair enough, I applied your patch, and sent Linus a pull request.

Cheers,
Samuel.


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
