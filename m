Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569Ab0BSWEB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Feb 2010 17:04:01 -0500
Received: from mail-yx0-f200.google.com ([209.85.210.200]:54201 "EHLO
	mail-yx0-f200.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab0BSWD7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Feb 2010 17:03:59 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xQ2223dno1Qz5o3DcaHJkESESXHdz8TkaXJNI7t7U6R37FAydkx1EyTZXkrde46lEK
         NDjStsrW6Hhc8p2rBe1EoJ/wAlklx9sPCGYgaF/UDpscYeuOqwsSpqNXGI6S/WYqQGrK
         hOZrAJqqaY7a3ch2sTe52GI8DXk36C9XnrMAk=
MIME-Version: 1.0
In-Reply-To: <m3wry8nbyl.fsf@lugabout.jhcloos.org>
References: <m3pr48bjfg.fsf@lugabout.jhcloos.org>
	 <20100215154516.GB11057@think> <m3d403632g.fsf@lugabout.jhcloos.org>
	 <21d7e9971002191302s76111f6fyd986c51b66e214ae@mail.gmail.com>
	 <m3wry8nbyl.fsf@lugabout.jhcloos.org>
Date: Sat, 20 Feb 2010 08:03:57 +1000
Message-ID: <21d7e9971002191403tdc16bf9h5ebf6b48fec95d6a@mail.gmail.com>
Subject: Re: [Regression] Filesystem I/O is CPU-bound in rc7 and rc8
From: Dave Airlie <airlied@gmail.com>
To: James Cloos <cloos@jhcloos.com>
Cc: linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>,
       linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
       linux-btrfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>
> OK.  I do use radeon kms (r100).

I've just sent a pull req to Linus
http://bugzilla.kernel.org/show_bug.cgi?id=15328
this

http://bugzilla.kernel.org/attachment.cgi?id=25107
patch.

The relevant piece of dmesg is at the top ;-), where
it states if you have PAT support or not, but I
suspect if you try this patch it'll fix it.

Dave.
