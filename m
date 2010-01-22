Return-Path: <linux-kernel-owner+w=401wt.eu-S1755828Ab0AVCPn@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755828Ab0AVCPn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jan 2010 21:15:43 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755800Ab0AVCPm
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Thu, 21 Jan 2010 21:15:42 -0500
Received: from keil-draco.com ([216.193.185.50]:50118 "EHLO
	mail.keil-draco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755778Ab0AVCPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jan 2010 21:15:41 -0500
From: Daniel Hazelton <dhazelton@enter.net>
To: Shu Wu <superwushu@gmail.com>
Subject: Re: Hi all, bug or design flaw?
Date: Thu, 21 Jan 2010 21:15:30 -0500
User-Agent: KMail/1.12.4 (Linux/2.6.31-17-generic; KDE/4.3.4; x86_64; ; )
Cc: Stepan Chatalyan <kehcho@gmail.com>, linux-kernel@vger.kernel.org
References: <22d9728d1001211705i4cf90df2ha730061ea01972b6@mail.gmail.com> <5c7d4fb81001211800k2bf2025bqea45a78292da2199@mail.gmail.com>
In-Reply-To: <5c7d4fb81001211800k2bf2025bqea45a78292da2199@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201001212115.31055.dhazelton@enter.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 January 2010 09:00:15 pm Shu Wu wrote:
> Hey, buddy, this is not the right place to raise a user-space
> question. But as for your question, you'd better to learn what the "."
> means. "#!/bin/bash" is used to indicate in shell when executed, while
> to be just a comment in the latter.
> 
> 2010/1/22 Stepan Chatalyan <kehcho@gmail.com>:
> > Hi there,
> >
> > I'm Stepan G. Chatalyan, and i think that I discovered a bug or design
> > flaw... and I don't know that it is provide from kernel...
> >
> > Let's see:
> >
> > (1) I mount /tmp with noexec,nosuid,nodev options
> >
> > /dev/hda6 on /tmp type ext3 (rw,noexec,nosuid,nodev,relatime)
> >
> > (2) I went to 'cd /tmp'`and I created a bash script, or another script
> > (perl, python, etc)... and chmod +x createdfile
> > script cointain:
> >
> > #!/bin/bash
> > echo "Probe..."
> >
> > (3) I tried to execut it with "./createdfile"
> > [kehcho@kehcho] [/tmp]$ ./createdfile
> > -bash: ./createdfile: /bin/bash: bad interpreter: Permission denied
> >
> > (4) I tried to execute it, but pass to bash ". /tmp/createdfile"
> >
> > [kehcho@tornadowt] [/tmp]$ . /tmp/createdfile
> > Probe...
> >
> > It is a kernel bug or I just report a another one?

This is not a bug at all. I'll just repeat Shu Wu's statement - learn what "." 
actually does. Note: it is *NOT* the same as $(...) or `...` - and it is not 
the same as directly executing a script.

DRH
