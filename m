Return-Path: <linux-kernel-owner+w=401wt.eu-S1757479AbYA1AUw@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757479AbYA1AUw (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jan 2008 19:20:52 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752923AbYA1AUn
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Sun, 27 Jan 2008 19:20:43 -0500
Received: from fg-out-1718.google.com ([72.14.220.156]:4623 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752702AbYA1AUn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jan 2008 19:20:43 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:organization:user-agent:mime-version:to:cc:subject:references:in-reply-to:content-type:content-transfer-encoding;
        b=PM+fkKlHv2G5rhv9FAf3+qtPzphfTt6NIK7h23oprXjo0vAUPbOgpwLHjIvmyeL3UCGySB9OdbXf2h9h8Mc8gLN7m99MItrOCk50+NAWCzviKgzNXTb/yspDVvz1N3uIe8zOvu2eZ3TlB3FSyD48ODG92RJ3LhYLkjQ8QWo6JgM=
Message-ID: <479D1FD1.2070105@gmail.com>
Date: Mon, 28 Jan 2008 03:20:33 +0300
From: Dmitri Vorobiev <dmitri.vorobiev@gmail.com>
Organization: DmVo Home
User-Agent: Thunderbird 1.5.0.14pre (X11/20071022)
MIME-Version: 1.0
To: Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com>
CC: Ingo Molnar <mingo@elte.hu>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] X86: coding style fixes to arch/x86/math-errors.c - take
 2
References: <20080127231527.2ea40804@paolo-desktop>	 <479D067E.3010100@gmail.com> <20080127224258.GA22018@elte.hu>	 <4d8e3fd30801271448ja6a44ferbf86d37c2f3b825@mail.gmail.com> <4d8e3fd30801271557i4310bc07ifbdea081001cc592@mail.gmail.com>
In-Reply-To: <4d8e3fd30801271557i4310bc07ifbdea081001cc592@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paolo Ciarrocchi пишет:
> On Jan 27, 2008 11:48 PM, Paolo Ciarrocchi <paolo.ciarrocchi@gmail.com> wrote:
>> On Jan 27, 2008 11:42 PM, Ingo Molnar <mingo@elte.hu> wrote:
...
> 
> How should I compare the .o file?
> Simply doing a md5sum or should I do a objdump -d before?
> Or a strip?
> 

Comparing the vmlinux images shoudls suffice. But you'll
have to make sure that the object file resulting from the
C source that you're changing gets linked into vmlinux.

Dmitri

> Ciao,

