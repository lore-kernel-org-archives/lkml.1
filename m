Return-Path: <linux-kernel-owner+w=401wt.eu-S1760693AbZEFS2d@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760693AbZEFS2d (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 14:28:33 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1753570AbZEFS2Y
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 14:28:24 -0400
Received: from outbound-mail-308.bluehost.com ([67.222.53.254]:42287 "HELO
	outbound-mail-308.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751677AbZEFS2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 14:28:24 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 May 2009 14:28:24 EDT
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=bsimKaeXZarrY6k2dfU1N0qj0F6nHwrnPEqHUD626J92e7AwoZ6fx0NqxAsG3bpZVlVNYTHL2Z10JT2sZepLgnTRnDKF80g55h3hpFgU6138JtCDi7CoLsI5wFNhSnoF;
Date: Wed, 6 May 2009 11:21:32 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Sylvain Meyer <sylvain.meyer@worldonline.fr>,
       Antonino Daplas <adaplas@gmail.com>
Subject: Re: 2.6.30-rc4-git1 -- LOCKUP -- Intelfb with kernel mode setting
 is  locking up my system when Xorg starts.
Message-ID: <20090506112132.3fd44b34@hobbes>
In-Reply-To: <a44ae5cd0905060925p4a9741ddyce96629ff54b39fa@mail.gmail.com>
References: <a44ae5cd0905052049i2f4cfdeia64fb1c147c4da67@mail.gmail.com>
	<a44ae5cd0905060759g7e237ecfq670a1ef0c8298b8c@mail.gmail.com>
	<a44ae5cd0905060925p4a9741ddyce96629ff54b39fa@mail.gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009 12:25:54 -0400
Miles Lane <miles.lane@gmail.com> wrote:

> I established an SSH connection to my laptop and then started Xorg
> from the ssh session.  I saw the startup messages get to the point
> where it specified which xorg.conf file was being used and then the
> ssh session froze and eventually timed out.  So, this doesn't seem to
> be an issue of just Xorg getting messed up.  Any guidance on what to
> test now would be greatly appreciated.

Are you getting a framebuffer console at bootup?  Looks like you're
using Ubuntu, https://wiki.ubuntu.com/X/KernelModeSetting might help.

-- 
Jesse Barnes, Intel Open Source Technology Center
