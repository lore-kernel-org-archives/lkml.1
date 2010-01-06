Return-Path: <linux-kernel-owner+w=401wt.eu-S1755834Ab0AFJwK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755834Ab0AFJwK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 04:52:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755773Ab0AFJwF
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 04:52:05 -0500
Received: from cantor.suse.de ([195.135.220.2]:59037 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744Ab0AFJwA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 04:52:00 -0500
Message-ID: <4B445D3E.8080600@suse.cz>
Date: Wed, 06 Jan 2010 10:51:58 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: Eric Miao <eric.y.miao@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: include only necessary in scripts/Makefile.modbuiltin
References: <f17812d71001052226y604995a0m4c7887d29fd73f90@mail.gmail.com>
In-Reply-To: <f17812d71001052226y604995a0m4c7887d29fd73f90@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.1.2010 07:26, Eric Miao wrote:
> scripts/Makefile.modbuiltin assumes either Kbuild or Makefile exists in
> every sub-directory, which is not true.

It assumes what there is a kbuild file in each directory listed in
subdir-[ym] or obj-[ym]. For which directory is this not true? Did you
see an actual build failure? The same include is used in
scripts/Makefile.build, where it has been working fine for ages...

Michal
