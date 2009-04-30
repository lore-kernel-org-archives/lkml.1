Return-Path: <linux-kernel-owner+w=401wt.eu-S1763742AbZD3Nv5@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763742AbZD3Nv5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Apr 2009 09:51:57 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1763601AbZD3NuW
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 30 Apr 2009 09:50:22 -0400
Received: from smtp3.netcologne.de ([194.8.194.66]:40294 "EHLO
	smtp3.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763588AbZD3NuS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Apr 2009 09:50:18 -0400
Date: Thu, 30 Apr 2009 15:50:16 +0200
From: Max Kellermann <max@duempel.org>
To: Vegard Nossum <vegard.nossum@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [splice PATCH 3/3] splice: added support for pipe-to-pipe
	splice()
Message-ID: <20090430135016.GA26868@squirrel.roonstrasse.net>
Mail-Followup-To: Vegard Nossum <vegard.nossum@gmail.com>,
	linux-kernel@vger.kernel.org
References: <20090430120342.5689.74090.stgit@rabbit.intern.cm-ag> <20090430120354.5689.75240.stgit@rabbit.intern.cm-ag> <19f34abd0904300635v2d8af8eeh1a8aa9cf6f4eb1c9@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19f34abd0904300635v2d8af8eeh1a8aa9cf6f4eb1c9@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2009/04/30 15:35, Vegard Nossum <vegard.nossum@gmail.com> wrote:
> What happens if you splice two pipes, in separate threads, to each
> other? :-)

As a demonstration, here's an experiment with older technology, when
pipes were still made of wood (pre-splice):

 mkfifo /tmp/foo
 cat /tmp/foo >/tmp/foo

You may launch the real thing now with a simple

 echo Hello World >tmp/foo

Warning: with only one pipe, you're likely to bend the pipe too far,
and it may break (SIGPIPE).

Max
