Return-Path: <linux-kernel-owner+w=401wt.eu-S1764278AbYCDRVa@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764278AbYCDRVa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2008 12:21:30 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760821AbYCDRVL
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 4 Mar 2008 12:21:11 -0500
Received: from cardassian3.kabelfoon.nl ([62.45.45.105]:58094 "EHLO
	cardassian.kabelfoon.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751717AbYCDRVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2008 12:21:09 -0500
X-Greylist: delayed 1205 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Mar 2008 12:21:09 EST
Message-ID: <47CD804C.8010606@caiway.nl>
Date: Tue, 04 Mar 2008 18:01:00 +0100
From: Jan Evert van Grootheest <j.e.van.grootheest@caiway.nl>
User-Agent: Thunderbird 2.0.0.12 (X11/20080227)
MIME-Version: 1.0
To: R H <robheilman@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: March 2008: Current state of oops/crash dumps
References: <a67db0c60803040835g78a5476dkdcefcd66fc696527@mail.gmail.com>
In-Reply-To: <a67db0c60803040835g78a5476dkdcefcd66fc696527@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

R H wrote:
> There is a lot of information on the web about Linux and oops/crash
> dumps.  Some positive, some quite negative.  There are lots of pages
> about tools, patches, best practices, etc.  The problem is that they
> all seem to be out of date.  I think the latest patch I have seen
> available was for 2.6.10.  All this data begs the question:
>
> What is the current state and roadmap for Linux kernel oops/crash dump
> capabilities?
>   
I'm sure that you've been looking at the Documentation/ tree
in the kernel sources? You should've come across netconsole
then. It will do just about the same as a serial console except
that it uses the network.
With newer kernels I don't think there's much need for
patches or tools. Although there are some things that you can
do to improve the stack traces (configure frame pointers, for
example).

-- Jan Evert

