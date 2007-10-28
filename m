Return-Path: <linux-kernel-owner+w=401wt.eu-S1754852AbXJ1ADB@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754852AbXJ1ADB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2007 20:03:01 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752011AbXJ1ACy
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 27 Oct 2007 20:02:54 -0400
Received: from scrub.xs4all.nl ([194.109.195.176]:1142 "EHLO scrub.xs4all.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751981AbXJ1ACy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2007 20:02:54 -0400
From: Roman Zippel <zippel@linux-m68k.org>
To: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: Kconfig: conf segfault (with invalid kconfig contents)
Date: Sun, 28 Oct 2007 02:02:45 +0200
User-Agent: KMail/1.9.7
Cc: Olof Johansson <olof@lixom.net>, linux-kernel@vger.kernel.org
References: <20071024031401.GA13376@lixom.net> <20071025213225.GB15292@uranus.ravnborg.org>
In-Reply-To: <20071025213225.GB15292@uranus.ravnborg.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <200710280202.46450.zippel@linux-m68k.org>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thursday 25 October 2007, Sam Ravnborg wrote:

> > It's clearly invalid in that it depends on what it selects, but it should
> > just abort instead.
>
> Thanks for the report and especially for the testcase!
> I will try to look at it a bit later if noone bites me (I'm afraid not).

Well, you're also responsible for it. :)
http://lkml.org/lkml/2007/5/6/14

It actually finds the recursive dependency, but it crashes because sym->prop 
is NULL.

bye, Roman
