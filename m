Return-Path: <linux-kernel-owner+w=401wt.eu-S1753480AbYCORWe@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753480AbYCORWe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Mar 2008 13:22:34 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751969AbYCORWZ
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 15 Mar 2008 13:22:25 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:48528 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751967AbYCORWY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Mar 2008 13:22:24 -0400
Date: Sat, 15 Mar 2008 18:14:05 +0100 (CET)
From: Roman Zippel <zippel@linux-m68k.org>
X-X-Sender: roman@scrub.home
To: Ray Lee <ray-lk@madrabbit.org>
cc: john stultz <johnstul@us.ibm.com>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org
Subject: Re: [PATCH 7/8] Remove current_tick_length()
In-Reply-To: <2c0942db0803150929q7cc628f8h18269f10daec8ab1@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0803151812020.1791@scrub.home>
References: <20080314184001.695807682@linux-m68k.org> 
 <20080314195737.153531685@linux-m68k.org>  <1205548860.6122.55.camel@localhost.localdomain>
  <Pine.LNX.4.64.0803150429500.1791@scrub.home>  <1205552909.6122.63.camel@localhost.localdomain>
  <Pine.LNX.4.64.0803150511580.1791@scrub.home>
 <2c0942db0803150929q7cc628f8h18269f10daec8ab1@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, 15 Mar 2008, Ray Lee wrote:

> Then make the original function an inline. With -O2 it should compile
> to exactly the same thing.

This would also defeat John's intention of keeping the value static.

bye, Roman
