Return-Path: <linux-kernel-owner+w=401wt.eu-S1750890AbZGNECL@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750890AbZGNECL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jul 2009 00:02:11 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750784AbZGNECJ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 14 Jul 2009 00:02:09 -0400
Received: from cantor.suse.de ([195.135.220.2]:35084 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750719AbZGNECI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jul 2009 00:02:08 -0400
Date: Mon, 13 Jul 2009 20:59:01 -0700
From: Greg KH <gregkh@suse.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>,
       Jaroslav Kysela <perex@perex.cz>, Liam Girdwood <lrg@slimlogic.co.uk>
Subject: Re: [PATCH 7/9] Sound: remove direct access of driver_data
Message-ID: <20090714035901.GA7657@suse.de>
References: <20090712223717.GB16600@kroah.com>
 <1247438766-17266-7-git-send-email-gregkh@suse.de>
 <20090713094401.GA24783@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20090713094401.GA24783@sirena.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 13, 2009 at 10:44:01AM +0100, Mark Brown wrote:
> On Sun, Jul 12, 2009 at 03:46:04PM -0700, Greg Kroah-Hartman wrote:
> > This is the last in-kernel direct usage of driver_data, replace it with
> > the proper dev_get/set_drvdata() calls.
> 
> Any objections to me applying this to ASoC, and if so do you want it in
> 2.6.31?

It's in Linus's tree now, so no need for you to do it :)

thanks,

greg k-h
