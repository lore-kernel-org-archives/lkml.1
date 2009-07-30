Return-Path: <linux-kernel-owner+w=401wt.eu-S1751143AbZG3MzO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751143AbZG3MzO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jul 2009 08:55:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1750938AbZG3MzN
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Jul 2009 08:55:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52107 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750912AbZG3MzM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jul 2009 08:55:12 -0400
Date: Thu, 30 Jul 2009 13:55:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Roger Quadros <quadros.roger@gmail.com>
Cc: lrg@slimlogic.co.uk, linux-kernel@vger.kernel.org
Subject: Re: regulator: adding enable control to fixed regulator interface
Message-ID: <20090730125510.GA9265@rakim.wolfsonmicro.main>
References: <b90c0690907300520t1dfbd722j73417b1beb6992bc@mail.gmail.com>
 <20090730123633.GA2739@rakim.wolfsonmicro.main>
 <b90c0690907300552h21157341v5820cf51261ddf42@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b90c0690907300552h21157341v5820cf51261ddf42@mail.gmail.com>
X-Cookie: I left my WALLET in the BATHROOM!!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 30, 2009 at 03:52:55PM +0300, Roger Quadros wrote:

> Yes using gpiolib makes sense. In this case we need to obtain GPIO number
> and enabling polarity (active high/low) through platform data.

Yes, you will need to add to the platform data.  I'd just not expect to
see any function pointers required.
