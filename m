Return-Path: <linux-kernel-owner+w=401wt.eu-S932262AbZGOUQQ@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932262AbZGOUQQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jul 2009 16:16:16 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S932205AbZGOUQP
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 15 Jul 2009 16:16:15 -0400
Received: from cantor.suse.de ([195.135.220.2]:41669 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142AbZGOUQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jul 2009 16:16:14 -0400
Message-ID: <4A5E390E.2040004@suse.cz>
Date: Wed, 15 Jul 2009 22:16:14 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Thunderbird 2.0.0.19 (X11/20081227)
MIME-Version: 1.0
To: Andreas Robinson <andr345@gmail.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, Scott James Remnant <scott@ubuntu.com>,
       linux-modules@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
       linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: generate modules.builtin
References: <20090526152540.GA28341@sepie.suse.cz>	 <20090703144547.GA20980@sepie.suse.cz>	 <1247675954.3968.140.camel@quest>	 <ac3eb2510907150946y461fee0dj6e8f5265b4f91215@mail.gmail.com>	 <cc43514a0907151104r6208a3dbm89dba496c1411fc0@mail.gmail.com>	 <4A5E2944.2070904@suse.cz> <cc43514a0907151312l34bc6c92m7986fd1f99cfca2c@mail.gmail.com>
In-Reply-To: <cc43514a0907151312l34bc6c92m7986fd1f99cfca2c@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andreas Robinson napsal(a):
> On Wed, Jul 15, 2009 at 9:08 PM, Michal Marek<mmarek@suse.cz> wrote:
>> The idea is that modprobe should just do nothing and exit successfully,
>> so that scripts don't break nor start printing warnings if the kernel
>> config changes. I meant to send it to linux-modules once there is
>> agreement about the modules.builtin file format.
> 
> Ok, that makes sense.
> 
> I think there's a small chance of confusion though, when a user tries
> to insert a module and it doesn't show up with lsmod. Perhaps you can
> add an info() message? Then the user can figure out what is happening
> with the --verbose option.

Good idea, will do that.

Michal
