Return-Path: <linux-kernel-owner+w=401wt.eu-S1755416AbYHHJ3R@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416AbYHHJ3R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2008 05:29:17 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752372AbYHHJ3E
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 8 Aug 2008 05:29:04 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:29913 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327AbYHHJ3D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2008 05:29:03 -0400
Date: Fri, 8 Aug 2008 11:28:53 +0200
From: Jean Delvare <khali@linux-fr.org>
To: mkrufky@linuxtv.org
Cc: sam@ravnborg.org, user.kernel@gmail.com, linux-kernel@vger.kernel.org,
       i2c@lm-sensors.org
Subject: Re: Problem with restricted I2C algorithms in kernel 2.6.26!
Message-ID: <20080808112853.22adbfae@hyperion.delvare>
In-Reply-To: <489B6A66.40605@linuxtv.org>
References: <489B6A66.40605@linuxtv.org>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Michael,

On Thu, 7 Aug 2008 17:34:30 -0400 , mkrufky@linuxtv.org wrote:
> Jean Delvare wrote:
> > Why not, please? A vast majority of drivers work fine that way today. I
> > am still waiting for someone to give me a good reason why some other
> > drivers supposedly can't be merged upstream (something better than
> > "believe me, it's impossible".)
> 
> Nobody said that a driver "...can't be merged upstream" ...  but 
> REQUIRING a driver to be merged upstream to allow development and / or 
> testing is a problem, IMHO.
> 
> If you required that all of my development happens within a git 
> development repository, preventing me from working against distro-kernel 
> xyz, then I would simply spend more time on Windows driver development 
> and my Linux contributions would cease.

Not my goal, obviously.

> External subsystem development repositories allow us to work against 
> stable kernels at our own pace.  When driver X is ready to be merged, it 
> gets merged.
>
> With the model that you propose, "use linux-next for development" ... 
> well then what about testing?  Who is going to test my driver if it 
> requires a full kernel compile?

Some distributions do package linux-next. And this seems to be a very
easy way to get end users to test bleeding edge code. You just tell the
user to install the linux-next package and he/she's done. No need to
build anything.

-- 
Jean Delvare
