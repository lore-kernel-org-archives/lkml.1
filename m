Return-Path: <linux-kernel-owner+w=401wt.eu-S1753510AbYISNzc@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753510AbYISNzc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2008 09:55:32 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1751371AbYISNz0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Fri, 19 Sep 2008 09:55:26 -0400
Received: from rv-out-0506.google.com ([209.85.198.232]:21956 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287AbYISNzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2008 09:55:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:sender:to:subject:cc:in-reply-to:mime-version
         :content-type:content-transfer-encoding:content-disposition
         :references:x-google-sender-auth;
        b=f1DM8JJn4VQsl6L6NXMx1ch2bGoPhLYl50SH1l71tU06vfnCgyM6XKgfA7wcpxKsh1
         MCVPSAeLeB1Ws8pXc56lip4yKMX8Sbg8ROdiImazN+wFjcA3o3xd8q+o5SvffHRjdp4f
         dHgW4xOOKbXLrN24kwC8L5eIveiiz/0nq/npo=
Message-ID: <b6c5339f0809190655l5b7a1641l8febd816237cc2b9@mail.gmail.com>
Date: Fri, 19 Sep 2008 09:55:22 -0400
From: "Bob Copeland" <me@bobcopeland.com>
To: "Andrey Vul" <andrey.vul@gmail.com>
Subject: Re: Some hfsplus questions
Cc: linux-kernel <linux-kernel@vger.kernel.org>
In-Reply-To: <e38d12ff0809181855n5ca173a9x452540e3dcdc9a9a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <e38d12ff0809181855n5ca173a9x452540e3dcdc9a9a@mail.gmail.com>
X-Google-Sender-Auth: 23ec64735abd14bc
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 18, 2008 at 9:55 PM, Andrey Vul <andrey.vul@gmail.com> wrote:
> I have some questions about hfsplus:
> 1) Is there a / how do you patch the fs driver / mount options to
> allow starting from an offset (f.e. certain DMG files' HFS+ superblock
> start at 32768)?

In general you do this with losetup(8) instead of in the filesystem itself,
since the FS generally doesn't care about the block device.

e.g. losetup -o 32768 ....

> 2) Is there a / how do you patch the fs driver to allow for
> transparent zlib decompression of the HFS+ volume (inside the DMG
> file)?

No idea.  A device mapper target (or fuse-over-loopback) could do that but
I don't know if there is something suitable already.

-- 
Bob Copeland %% www.bobcopeland.com
