Return-Path: <linux-kernel-owner+w=401wt.eu-S1755600Ab0AFLrK@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755600Ab0AFLrK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 06:47:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755501Ab0AFLrI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 06:47:08 -0500
Received: from cantor2.suse.de ([195.135.220.15]:54161 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754672Ab0AFLrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 06:47:07 -0500
Message-ID: <4B447836.9020004@suse.cz>
Date: Wed, 06 Jan 2010 12:47:02 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091130 SUSE/3.0.0-1.2 Thunderbird/3.0
MIME-Version: 1.0
To: Eric Miao <eric.y.miao@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kbuild: include only necessary in scripts/Makefile.modbuiltin
References: <f17812d71001052226y604995a0m4c7887d29fd73f90@mail.gmail.com> 	<4B445D3E.8080600@suse.cz> <f17812d71001060231l5c0ca1bha50e395790d0fc0b@mail.gmail.com> 	<4B44684B.1060401@suse.cz> <f17812d71001060322j4970349ex52f0cfa495ac8628@mail.gmail.com>
In-Reply-To: <f17812d71001060322j4970349ex52f0cfa495ac8628@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6.1.2010 12:22, Eric Miao wrote:
> And indeed it's strange - while scripts/Makefile.build doesn't fail since
> there seems to be a script that generates some Makefiles in between
> the build process, I'll get this figured out to see what is the root
> cause.

Oh. If that turns out to be the cause and the script is going to stay,
then the right fix would be to change the toplevel Makefile generate the
modules.builtin files in a separate target after the build, and not in
parallel. I planed to do this change anyway, to later avoid regenerating
the modules.builtin files if the config didn't change.

Michal
