Return-Path: <linux-kernel-owner+w=401wt.eu-S1755835AbYLCHhV@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835AbYLCHhV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2008 02:37:21 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753600AbYLCHhI
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 3 Dec 2008 02:37:08 -0500
Received: from moutng.kundenserver.de ([212.227.126.188]:61003 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579AbYLCHhG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2008 02:37:06 -0500
Date: 02 Dec 2008 19:00:00 +0100
From: lirc@bartelmus.de (Christoph Bartelmus)
To: pavel@suse.cz
Cc: jonsmirl@gmail.com
Cc: jrm8005@gmail.com
Cc: linux-kernel@vger.kernel.org
Message-ID: <Ar6VqEpojFB@christoph>
In-Reply-To: <20081123180146.GA7731@ucw.cz>
Subject: Re: In-kernel IR remote control support
User-Agent: OpenXP/4.10.7369 (Linux) (i386)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Provags-ID: V01U2FsdGVkX1+CGDeCU019swVNQyfq/9ILWQhuu5oV6jPZLrZ
 /lCMsZUv/GUJFhL07Ao9u80ToKdLtmBR6oc4Mz1cMiPqgSJt9J
 RAVNDqjq9M/lm5GYaBljgMau2hv+Cp7grukFliIF2k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Pavel,

on 23 Nov 08 at 19:01, Pavel Machek wrote:
[...]
>>> support for the common remotes. That seems like a net plus to me, and
>>> you can still keep the obscure ones in userland.
>>
>> Jon's code and the LIRC approach exclude each other. It does not make
>> sense to have both in the kernel. There have been attempts to clean up
>> LIRC code to be included in the kernel. The current discussion lessens my
>> hope that this will happen anytime soon.

> I don't see why we could not use Jon's code for common remotes decoded
> mostly by hw, and your code for the obscure cases.

Ok, how about this:
there's one common point in lirc_dev where all IR timing data is handled.
Jon's code can grab the data at this point and feed it into its state  
machine. That way there's no need to change any of the existing drivers.
And we all work together to get this stuff ready for inclusion into the  
kernel.

Christoph
