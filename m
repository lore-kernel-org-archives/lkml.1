Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab0CDIDP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Mar 2010 03:03:15 -0500
Received: from mail.gmx.net ([213.165.64.20]:45874 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753651Ab0CDIDO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Mar 2010 03:03:14 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/0+BVaH5L0yDBH/ZDGrLzS1OJj9bQaZQ2Nw4WvVH
	WFThVUlnaiJp3G
Subject: Re: evdev keyboard driver stopped working after upgrading from
 Kernel  2.6.33-rc8 to 2.6.33 (official release)
From: Mike Galbraith <efault@gmx.de>
To: Zeno Davatz <zdavatz@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <40a4ed591003032355t46e356f8qadfded7450934b51@mail.gmail.com>
References: <40a4ed591003031245g79cca873t89e90545337a9067@mail.gmail.com>
	 <1267673633.6416.7.camel@marge.simson.net>
	 <40a4ed591003032322l4ad2dc00sd3de718b5a76089b@mail.gmail.com>
	 <1267688823.7029.8.camel@marge.simson.net>
	 <40a4ed591003032355t46e356f8qadfded7450934b51@mail.gmail.com>
Content-Type: text/plain
Date: Thu, 04 Mar 2010 09:03:11 +0100
Message-Id: <1267689791.10101.4.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
X-FuHaFi: 0.67000000000000004
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-03-04 at 08:55 +0100, Zeno Davatz wrote:

> Ok, I will try that. Can you give a short input of how I should start bisecting?

git bisect start
git bisect good v2.6.33-rc8
git bisect bad v2.6.33

build and test each iteration, should be quick/painless if it's rc8.

	-Mike

