Return-Path: <linux-kernel-owner+w=401wt.eu-S1759659AbYDVQ7H@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759659AbYDVQ7H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2008 12:59:07 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755231AbYDVQ64
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 22 Apr 2008 12:58:56 -0400
Received: from xenotime.net ([66.160.160.81]:33874 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754740AbYDVQ6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2008 12:58:55 -0400
Date: Tue, 22 Apr 2008 09:58:44 -0700 (PDT)
From: "Randy.Dunlap" <rdunlap@xenotime.net>
X-X-Sender: rddunlap@shark.he.net
To: Sanjeev Aditya Naga <sanjeev.kernel@gmail.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: config file part of kernel!
In-Reply-To: <5681ec900804220953g187b792eib424c7af4cd3df4f@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.0804220956390.4897@shark.he.net>
References: <5681ec900804220953g187b792eib424c7af4cd3df4f@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Apr 2008, Sanjeev Aditya Naga wrote:

> Hi,
> 
> Will it be good, if we make the `config` file (used to
> build a kernel) part of the built kernel. So that one in
> need, can extract it from the kernel using some
> userspace tool!?
> 
> During the configuration of kernel, we usually set
> the required functionality. However, if we delete the
> sources/config file or loose the config file, but later
> we wanted to add up some module(s) to the same
> kernel, it'd be great if we will be able to extract some
> info from the kernel along with the config params!??

This is already possible.

CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y

The former includes the config file in the kernel image.
The latter one puts it into /proc/config.gz as well.

-- 
~Randy
