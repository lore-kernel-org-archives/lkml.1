Return-Path: <linux-kernel-owner+w=401wt.eu-S1755720Ab0AFKc3@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab0AFKc3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jan 2010 05:32:29 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755661Ab0AFKc2
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 Jan 2010 05:32:28 -0500
Received: from qw-out-2122.google.com ([74.125.92.27]:13277 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638Ab0AFKc2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jan 2010 05:32:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=doyxTu3js/wUi4GM//PY4Jeyfu8528mBfJ8rk+sWvnIv6ulB34kTD3nWCggaNc6SV0
         VSDbW5xy4iTROG4pwmqAdkb7ykCqILxHwQN7N7GSeWY9YQDwlUP9ndOVfHnmeJwjIt78
         zFQXMGsdoU3v1j5b53goz6YdQc2gY+vejtWuk=
MIME-Version: 1.0
In-Reply-To: <4B445D3E.8080600@suse.cz>
References: <f17812d71001052226y604995a0m4c7887d29fd73f90@mail.gmail.com> 
	<4B445D3E.8080600@suse.cz>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Wed, 6 Jan 2010 18:31:13 +0800
Message-ID: <f17812d71001060231l5c0ca1bha50e395790d0fc0b@mail.gmail.com>
Subject: Re: [PATCH] kbuild: include only necessary in scripts/Makefile.modbuiltin
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 6, 2010 at 5:51 PM, Michal Marek <mmarek@suse.cz> wrote:
> On 6.1.2010 07:26, Eric Miao wrote:
>> scripts/Makefile.modbuiltin assumes either Kbuild or Makefile exists in
>> every sub-directory, which is not true.
>
> It assumes what there is a kbuild file in each directory listed in
> subdir-[ym] or obj-[ym]. For which directory is this not true? Did you
> see an actual build failure? The same include is used in
> scripts/Makefile.build, where it has been working fine for ages...
>

Well, it's in my tree outside mainline, I have to make this change
to get it build. And'm wondering if that's a correct assumption.
