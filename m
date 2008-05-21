Return-Path: <linux-kernel-owner+w=401wt.eu-S935116AbYEUGvf@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935116AbYEUGvf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 May 2008 02:51:35 -0400
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1756948AbYEUGv0
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Wed, 21 May 2008 02:51:26 -0400
Received: from an-out-0708.google.com ([209.85.132.242]:1804 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756784AbYEUGvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 May 2008 02:51:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:to:subject:cc:in-reply-to:mime-version:content-type:content-transfer-encoding:content-disposition:references;
        b=WP610c91Tzm5Ep1kXTde3+kaYugDxchm2XUiQjomQGJbwPxA4/ZWLDdbVu+tcdXPy5Sj9c579s+bZ2cE71r0LfrZkdJFK8arfsQuDJf8QBgDy+uOVptCLhriWjM+pvyR5qhXQ/XbId/aNlPOF7mWns6e9G9XKtx4GHoKGtKHxfk=
Message-ID: <dd18b0c30805202351h133147adg5bb526e3f74e3bd6@mail.gmail.com>
Date: Wed, 21 May 2008 06:51:24 +0000
From: "Justin Mattock" <justinmattock@gmail.com>
To: "Andrew Morton" <akpm@linux-foundation.org>
Subject: Re: completely lost as to what to do, or where to look.
Cc: "Linux Kernel Mailing List" <linux-kernel@vger.kernel.org>
In-Reply-To: <20080520223410.9a8f200d.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
References: <dd18b0c30805202110x7c412b3bq523f91d968072482@mail.gmail.com>
	 <20080520223410.9a8f200d.akpm@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 21, 2008 at 5:34 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 21 May 2008 04:10:16 +0000 "Justin Mattock" <justinmattock@gmail.com> wrote:
>
>> Hello; I'm lost as to where to look in the kernel, as to why I'm
>> receiving a black screen with startx
>> DRI seems to be fine, I'm noticing a sema_init but am not sure if this
>> is the cause of the blackness.
>> any direction as to where I might look would be helpful.
>
> Kernel version?
>
> A git-bisect should get you down the the offending commit within an
> hour or three.  http://www.kernel.org/doc/local/git-quick.html has some
> instructions.
>
> But if you're on 2.6.26-rcX, be sure to use the very latest - a pile of
> bad DRI code got reverted recently.  This morning, I think.
>

Thanks for the help, From what I can remember I noticed this around
2.6.26-rc1. It could be an issue with DRI, but then again it could be
something else. With running some more tests I'm noticing  a conflict
with libdri.so, not recognizing the module or the module not
recognizing libdri.so.  As for the latest git I'll have to pull, and
see if it makes  a difference.  If not then I'll have to sit and keep
working this problem until I can figure what is happening  "even if my
eye ball's fall out of my sockets", and I walk around feeling like
I've had brain surgery".
regards;
-- 
Justin P. Mattock
