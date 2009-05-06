Return-Path: <linux-kernel-owner+w=401wt.eu-S1760001AbZEFSbt@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760001AbZEFSbt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 May 2009 14:31:49 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1757405AbZEFSbi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 6 May 2009 14:31:38 -0400
Received: from outbound-mail-107.bluehost.com ([69.89.22.7]:60464 "HELO
	outbound-mail-107.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755783AbZEFSbh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 May 2009 14:31:37 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=tbTpqbTeR7lR62vnTMuLvPJBn4hQI26phOlnyYLk3su2ssWw+IpWOhUmYOA1Rn4C8FxJxsSYNFFBYDJGGi51tq4jb88TwH1HEo8fW8HxHXxsV5IIAHPy9sE3lwrbE0Tk;
Date: Wed, 6 May 2009 11:31:32 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Sylvain Meyer <sylvain.meyer@worldonline.fr>,
       Antonino Daplas <adaplas@gmail.com>
Subject: Re: 2.6.30-rc4-git1 -- LOCKUP -- Intelfb with kernel mode setting
 is  locking up my system when Xorg starts.
Message-ID: <20090506113132.6ca2d7a3@hobbes>
In-Reply-To: <a44ae5cd0905061125w4044fd50l6f30a1ca9a5b1396@mail.gmail.com>
References: <a44ae5cd0905052049i2f4cfdeia64fb1c147c4da67@mail.gmail.com>
	<a44ae5cd0905060759g7e237ecfq670a1ef0c8298b8c@mail.gmail.com>
	<a44ae5cd0905060925p4a9741ddyce96629ff54b39fa@mail.gmail.com>
	<20090506112132.3fd44b34@hobbes>
	<a44ae5cd0905061125w4044fd50l6f30a1ca9a5b1396@mail.gmail.com>
X-Mailer: Claws Mail 3.7.1 (GTK+ 2.16.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.111.28.251 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 6 May 2009 14:25:46 -0400
Miles Lane <miles.lane@gmail.com> wrote:

> Yes, the framebuffer console works fine if I boot "single".  Then, the
> system hangs when I run xinit.
> I will check out the page on the Ubuntu site. Thanks!

Ok, my guess is that xf86-video-intel is doing something bad since it's
not built with KMS support.  The Ubuntu site should help with that
though.

-- 
Jesse Barnes, Intel Open Source Technology Center
