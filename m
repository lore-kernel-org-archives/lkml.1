Return-Path: <linux-kernel-owner+w=401wt.eu-S1764914AbXGQObp@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764914AbXGQObp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2007 10:31:45 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1752937AbXGQObi
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Tue, 17 Jul 2007 10:31:38 -0400
Received: from nz-out-0506.google.com ([64.233.162.236]:64840 "EHLO
	nz-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752244AbXGQObg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2007 10:31:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=beta;
        h=received:message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=hY4x++YyM/ni6/zgnTQ9X6qyvqdoqqF+U2cl0Mgj1A4LuHEsE2bTII7drPrVagEAcHCuP1v7LBiaUDuv1c3/PMYhDrbAsdLNQ4aevY1thVI4bMHNMIP5xVv04q0nptyHyVY05GkR25w/l0jmUTc0XbtPyyO/woYO+HiVthCyA1M=
Message-ID: <9a8748490707170731m28e86e92nf486ba7ae8e6e838@mail.gmail.com>
Date: Tue, 17 Jul 2007 16:31:34 +0200
From: "Jesper Juhl" <jesper.juhl@gmail.com>
To: "Sasa Ostrouska" <casaxa@gmail.com>
Subject: Re: VESAFB CUSTOM RESOLUTION
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <dcf706c60707170713t605ce652r83b5b53f3c315691@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dcf706c60707170713t605ce652r83b5b53f3c315691@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/07/07, Sasa Ostrouska <casaxa@gmail.com> wrote:
> Hi ,
>
> I want to ask one question about a custom resolution in the console.
> I have a Sony Vaio Laptop VGN-SZ2VP/X, the screen resolution is
> 1280x800, now I'm using the vga=773 which is an 1024x768 but this is
> ugly as I get a border of about 2-3cm on one the sides of the screen.
> So is there a way that I set the 1280x800 resolution at boot time ?
>
See these documents:
 Documentation/fb/vesafb.txt
 Documentation/fb/fbcon.txt
 Documentation/svga.txt
 Documentation/i386/boot.txt
 Documentation/kernel-parameters.txt

Have you tried something like this?
 vga=0x360 video=vesafb:mtrr,1280x800-16@72


-- 
Jesper Juhl <jesper.juhl@gmail.com>
Don't top-post  http://www.catb.org/~esr/jargon/html/T/top-post.html
Plain text mails only, please      http://www.expita.com/nomime.html
