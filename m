Return-Path: <linux-kernel-owner+w=401wt.eu-S1753117AbYCPKOr@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117AbYCPKOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Mar 2008 06:14:47 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751773AbYCPKOk
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 16 Mar 2008 06:14:40 -0400
Received: from saeurebad.de ([85.214.36.134]:37922 "EHLO saeurebad.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751747AbYCPKOj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Mar 2008 06:14:39 -0400
From: Johannes Weiner <hannes@saeurebad.de>
To: "Peter Teoh" <htmldeveloper@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: spin_lock after get_cpu_var()
References: <804dabb00803160124p1240abe1v842821e988fdeca7@mail.gmail.com>
Date: Sun, 16 Mar 2008 11:12:45 +0100
In-Reply-To: <804dabb00803160124p1240abe1v842821e988fdeca7@mail.gmail.com>
	(Peter Teoh's message of "Sun, 16 Mar 2008 16:24:02 +0800")
Message-ID: <87ve3n0yg2.fsf@saeurebad.de>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.0.60 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

"Peter Teoh" <htmldeveloper@gmail.com> writes:

> I find it quite puzzling (no where else in kernel source is this
> found) that you would want to apply spin_lock() after get_cpu_var().
> The fddef is already percpu, so there is no need to lock it, right?
>
> I submitted this patch before, but got no response, just trying my
> luck this time :-).

http://lkml.org/lkml/2008/3/14/208

	Hannes
