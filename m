Return-Path: <linux-kernel-owner+w=401wt.eu-S1753168AbYECTNS@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753168AbYECTNS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2008 15:13:18 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751852AbYECTNI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 3 May 2008 15:13:08 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:2046 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751847AbYECTNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2008 15:13:07 -0400
Date: Sat, 3 May 2008 21:12:57 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
       Kay Sievers <kay.sievers@vrfy.org>, Linux I2C <i2c@lm-sensors.org>
Subject: Re: [PATCH] modpost: i2c aliases need no trailing wildcard
Message-ID: <20080503211257.389a0607@hyperion.delvare>
In-Reply-To: <20080503180420.GA17990@uranus.ravnborg.org>
References: <20080502203721.70c5dc09@hyperion.delvare>
	<20080503180420.GA17990@uranus.ravnborg.org>
X-Mailer: Claws Mail 3.3.1 (GTK+ 2.10.6; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

On Sat, 3 May 2008 20:04:20 +0200, Sam Ravnborg wrote:
> On Fri, May 02, 2008 at 08:37:21PM +0200, Jean Delvare wrote:
> > Hi all,
> > 
> > [Once more with Sam's address fixed, sorry for the noise.]
> > 
> > Not all device types need a wildcard at the end of their module
> > aliases. In particular, for i2c module aliases, the trailing wildcard
> > is not only unneeded, it could also cause the wrong driver to be
> > loaded.
> ...
> Hi Jean.
> 
> Do you expect me to take this via kbuild.git?

At your option. If it's easier for you to synchronize with other
patches possibly touching this file, please do. If not, I can push it
via my i2c tree. Just let me know.

-- 
Jean Delvare
