Return-Path: <linux-kernel-owner+w=401wt.eu-S1760381AbZEFSZ4@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760381AbZEFSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 14:25:56 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755357AbZEFSZr
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 14:25:47 -0400
Received: from mail-gx0-f166.google.com ([209.85.217.166]:60059 "EHLO
	mail-gx0-f166.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751677AbZEFSZq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 14:25:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iefBVuPp5DBfewPjaGu51VhkS5WAY0K9ePs+PNCFpRVBHU4/qACWQL1hewur1SxJpB
         Y9bYWHdCG6qY7HxILxfNT9pFKdRI1+SFkE10eHCsUupgJk0WLH8jzszjYn0DUMECok7I
         XzOjxxRT2EfumW9vvtI91XdBfpHShmAIhSVNc=
MIME-Version: 1.0
In-Reply-To: <20090506112132.3fd44b34@hobbes>
References: <a44ae5cd0905052049i2f4cfdeia64fb1c147c4da67@mail.gmail.com>
	 <a44ae5cd0905060759g7e237ecfq670a1ef0c8298b8c@mail.gmail.com>
	 <a44ae5cd0905060925p4a9741ddyce96629ff54b39fa@mail.gmail.com>
	 <20090506112132.3fd44b34@hobbes>
Date: Wed, 6 May 2009 14:25:46 -0400
Message-ID: <a44ae5cd0905061125w4044fd50l6f30a1ca9a5b1396@mail.gmail.com>
Subject: Re: 2.6.30-rc4-git1 -- LOCKUP -- Intelfb with kernel mode setting is 
	locking up my system when Xorg starts.
From: Miles Lane <miles.lane@gmail.com>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Sylvain Meyer <sylvain.meyer@worldonline.fr>,
       Antonino Daplas <adaplas@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Yes, the framebuffer console works fine if I boot "single".  Then, the
system hangs when I run xinit.
I will check out the page on the Ubuntu site. Thanks!

      Miles

On Wed, May 6, 2009 at 2:21 PM, Jesse Barnes <jbarnes@virtuousgeek.org> wrote:
> On Wed, 6 May 2009 12:25:54 -0400
> Miles Lane <miles.lane@gmail.com> wrote:
>
>> I established an SSH connection to my laptop and then started Xorg
>> from the ssh session.  I saw the startup messages get to the point
>> where it specified which xorg.conf file was being used and then the
>> ssh session froze and eventually timed out.  So, this doesn't seem to
>> be an issue of just Xorg getting messed up.  Any guidance on what to
>> test now would be greatly appreciated.
>
> Are you getting a framebuffer console at bootup?  Looks like you're
> using Ubuntu, https://wiki.ubuntu.com/X/KernelModeSetting might help.
>
> --
> Jesse Barnes, Intel Open Source Technology Center
>
