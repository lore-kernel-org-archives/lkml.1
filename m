Return-Path: <linux-kernel-owner+w=401wt.eu-S1753000AbXBJESK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753000AbXBJESK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Feb 2007 23:18:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753001AbXBJESK
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 9 Feb 2007 23:18:10 -0500
Received: from nigel.suspend2.net ([203.171.70.205]:34831 "EHLO
	nigel.suspend2.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753000AbXBJESJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Feb 2007 23:18:09 -0500
Subject: Re: NAK new drivers without proper power management?
From: Nigel Cunningham <nigel@nigel.suspend2.net>
Reply-To: nigel@nigel.suspend2.net
To: Dmitry Torokhov <dtor@insightbb.com>
Cc: Robert Hancock <hancockr@shaw.ca>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jeff Garzik <jeff@garzik.org>
In-Reply-To: <200702092227.22283.dtor@insightbb.com>
References: <fa.xSKPgY66Q+DPCZ1pszFFfdrJ0To@ifi.uio.no>
	 <45CD24F6.8090107@shaw.ca> <1171073149.3863.4.camel@nigel.suspend2.net>
	 <200702092227.22283.dtor@insightbb.com>
Content-Type: text/plain
Date: Sat, 10 Feb 2007 15:18:05 +1100
Message-Id: <1171081085.10170.7.camel@nigel.suspend2.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.8.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry!

On Fri, 2007-02-09 at 22:27 -0500, Dmitry Torokhov wrote:
> Hi Nigel,
> 
> On Friday 09 February 2007 21:05, Nigel Cunningham wrote:
> > [   17.684475] Device driver serio0 lacks bus and class support for being resumed.
> > [   17.684724] Device driver serio1 lacks bus and class support for being resumed.
> > [   17.684874] Device driver psaux lacks bus and class support for being suspended or resumed.
> > [   17.685015] Device driver serio2 lacks bus and class support for being resumed.
> > [   18.373576] Device driver serio3 lacks bus and class support for being resumed.
> > [   18.375666] Device driver serio4 lacks bus and class support for being resumed.
> > 
> 
> You should probably only warn if driver does not have resume method - not
> having suspend is quite valid if driver is able to restore state at resume
> without explicitely saving anything at suspend time.

Can do. Will do :)

Nigel

