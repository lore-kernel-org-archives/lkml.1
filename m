Return-Path: <linux-kernel-owner+w=401wt.eu-S1756207AbZBBL1Y@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207AbZBBL1Y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Feb 2009 06:27:24 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S1755900AbZBBL1H
	(ORCPT <rfc822;linux-kernel-outgoing>);
	Mon, 2 Feb 2009 06:27:07 -0500
Received: from mail-bw0-f12.google.com ([209.85.218.12]:52514 "EHLO
	mail-bw0-f12.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751AbZBBL1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Feb 2009 06:27:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=s/uuwWyD0GGiwcrCZvTcGudhLk28YCI98hy3q8IySNntKEvVPXu/GCi2DL+9rWCslE
         0l8cZkFY4bJv2b8X2HC7NPlGeY/WKUB9mlNWOWMrK5MGdFuf4LohDHoGP0pmR/uaZtUZ
         LQzbmcFF8oZajRjFkn0MdSU/A/bHvrASOZGYY=
MIME-Version: 1.0
In-Reply-To: <20090127091455.GB8543@atrey.karlin.mff.cuni.cz>
References: <bcb3ef430901150110nc4ced93w50c662ac512f8552@mail.gmail.com>
	 <20090116085326.GC4795@atrey.karlin.mff.cuni.cz>
	 <bcb3ef430901161443y5843d951m1cdee28dd588d006@mail.gmail.com>
	 <20090119191720.GB6463@ucw.cz>
	 <bcb3ef430901200035y33cea7e6hcf78ac1df01c99d2@mail.gmail.com>
	 <20090127091455.GB8543@atrey.karlin.mff.cuni.cz>
Date: Mon, 2 Feb 2009 12:21:42 +0100
Message-ID: <bcb3ef430902020321k37e312f2qb875ac754037953c@mail.gmail.com>
Subject: Re: Suspend/resume works in 2.6.29-0.19.rc0.git9.fc11.i686, but fails 
	in later versions
From: MartinG <gronslet@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2009 at 10:14 AM, Pavel Machek <pavel@suse.cz> wrote:
> Well, git bisect is always an option...? Or getting disk encryption
> out of place? Trying minimal config?

Wow, git bisect seems like a pretty powerful tool - I've never used it
before, but will try to look into it.

FWIW, I am able to suspend/resume *once* with
kernel-2.6.29-0.73.rc3.git2.fc11.i686, but on the second try, I am not
able to resume.

Same goes for kernel-2.6.29-0.74.rc3.git3.fc11.i686, ie. powerup ok,
suspend ok, resume ok, suspend again ok, resume not ok -> freeze (no
keyboard, black screen, no hdd action, hard reset needed).

I'll look into git and try to download and compile a couple of
kernels. I'll post back if I have any success.

Thanks,
MartinG
