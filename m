Return-Path: <linux-kernel-owner+w=401wt.eu-S1755799AbYFJJoO@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755799AbYFJJoO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2008 05:44:14 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751329AbYFJJoD
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 10 Jun 2008 05:44:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53505 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751014AbYFJJoB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2008 05:44:01 -0400
Date: Tue, 10 Jun 2008 10:43:59 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] generic GPIO parameter API
Message-ID: <20080610094359.GC6053@rakim.wolfsonmicro.main>
Mail-Followup-To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
	David Brownell <david-b@pacbell.net>, linux-kernel@vger.kernel.org
References: <Pine.LNX.4.64.0806021841500.30390@axis700.grange> <200806052229.37143.david-b@pacbell.net> <Pine.LNX.4.64.0806091109120.21876@axis700.grange> <20080609165438.GE17278@sirena.org.uk> <Pine.LNX.4.64.0806091906420.25460@axis700.grange>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0806091906420.25460@axis700.grange>
X-Cookie: Not recommended for children.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 09, 2008 at 07:09:00PM +0200, Guennadi Liakhovetski wrote:

> The primary purpose of the GPIO-parameter proposal was to allow to 
> configure these parameters from the user-space over sysfs by extending the 
> gpio-sysfs patch. And I2S master / slave operation should not be 
> switchable over sysfs, should it?

Not via that API, anyway (apart from anything else both ends of the link
need to agree) - I was more mentioning it as an example of a non-GPIO
function that could use the GPIO configuration.
