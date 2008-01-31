Return-Path: <linux-kernel-owner+w=401wt.eu-S934789AbYAaWS1@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934789AbYAaWS1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2008 17:18:27 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1760381AbYAaWSS
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 31 Jan 2008 17:18:18 -0500
Received: from 1wt.eu ([62.212.114.60]:1659 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759696AbYAaWSR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2008 17:18:17 -0500
Date: Thu, 31 Jan 2008 22:37:11 +0100
From: Willy Tarreau <w@1wt.eu>
To: Santiago Garcia Mantinan <manty@manty.net>
Cc: linux-kernel@vger.kernel.org
Subject: Re: dl2k stopped working on 2.6.24
Message-ID: <20080131213711.GM8953@1wt.eu>
References: <20080125211153.GA10203@dis.manty.net> <20080128233334.GA14326@dis.manty.net> <20080131215541.GA22018@dis.manty.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20080131215541.GA22018@dis.manty.net>
User-Agent: Mutt/1.5.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Santiago,

On Thu, Jan 31, 2008 at 10:55:41PM +0100, Santiago Garcia Mantinan wrote:
> As I didn't get any ideas on what to do to help find the problem with the
> dl2k driver, I'm doing some tests to get to know what has broken it.
> 
> I have today compiled dl2k from git, the version with the 2007-12-23 patches
> from Al Viro: dl2k endianness fixes (.24 fodder?) Right before the Al Viro
> patches. This seems to be working perfectly on my system.

I thought about those patches when you reported your problem but they
looked correct at first glance, and generally Al is known for pushing
clean and valid work.

> I'm wondering if I can apply the patches by Al Viro one by one to know which
> one broke it.

Yes it should be possible, people generally try to push incrementally
valid patches. Please CC Al with your findings. Maybe you'll get him
caught with a bug in his fixes, but get prepared to get fried on your
chair if you're wrong :-)

It is also possible that the code he fixed was really buggy but worked
because of another bug remaining somewhere else.

Regards,
Willy

