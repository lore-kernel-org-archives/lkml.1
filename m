Return-Path: <linux-kernel-owner+w=401wt.eu-S1756051AbZGDLlg@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051AbZGDLlg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jul 2009 07:41:36 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753249AbZGDLl1
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sat, 4 Jul 2009 07:41:27 -0400
Received: from 41-052.adsl.zetnet.co.uk ([194.247.41.52]:37689 "EHLO
	mail.esperi.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752964AbZGDLl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jul 2009 07:41:26 -0400
To: Andi Kleen <andi@firstfloor.org>
Cc: xb <xavier.bru@bull.net>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Xeon 5500 series support in kernel
References: <4A4C770F.6000709@bull.net> <877hyrbeon.fsf@basil.nowhere.org>
From: Nix <nix@esperi.org.uk>
Emacs: more than just a Lisp interpreter, a text editor as well!
Date: Sat, 04 Jul 2009 12:41:15 +0100
In-Reply-To: <877hyrbeon.fsf@basil.nowhere.org> (Andi Kleen's message of "2 Jul 2009 10:48:06 +0100")
Message-ID: <87k52o65gk.fsf@hades.wkstn.nix>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) XEmacs/21.5-b28 (linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-DCC-CTc-dcc2-Metrics: hades 1031; Body=3 Fuz1=3 Fuz2=3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2 Jul 2009, Andi Kleen outgrape:

> xb <xavier.bru@bull.net> writes:
>
>> I wonder if there are specific kernel configuration parameters that
>> allow to optimize performances on the recent Xeon 5500 processors (aka
>> Nehalem).
>
> The most important optimization is to use a 64bit kernel with NUMA
> support enabled (even if you use 32bit userland)

Surely NUMA only benefits you if you have a >1 socket system? Where's
the nonuniform access on a 1-socket machine? Every core is as far from
all the RAM as every other core, isn't it?
